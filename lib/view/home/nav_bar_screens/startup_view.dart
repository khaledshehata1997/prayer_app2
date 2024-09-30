import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:adhan/adhan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prayer_app/view/auth/sign_in_view.dart';
import 'package:prayer_app/view/home/dailyGoals.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModelCurrent.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/sqlite/database_helper.dart';
import 'package:prayer_app/view/home/nav_bar_screens/qiblah.dart';
import 'package:intl/intl.dart' as intl;
import 'package:prayer_app/view/home/profile.dart';
import 'package:prayer_app/view/home/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../provider/boolNotifier.dart';
import '../../../provider/prayer_provider.dart';
import '../../../services/notification.dart';
import '../../roqua_view.dart';
import '../../sibha/sibha_view.dart';

class PrayerTimes {
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  PrayerTimes({required this.fajr, required this.dhuhr, required this.asr, required this.maghrib, required this.isha});

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    // Assuming the date is for the current day
    DateTime now = DateTime.now();
    String currentDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    DateTime parseTime(String time) {
      // Assuming the API returns time in HH:mm format without timezone info
      // Parse it and then adjust to the local time zone
      DateTime dateTime = DateTime.parse("$currentDate $time:00");
      return dateTime.toLocal();  // Convert to local time if needed
    }

    return PrayerTimes(
      fajr: parseTime(json['Fajr']),
      dhuhr: parseTime(json['Dhuhr']),
      asr: parseTime(json['Asr']),
      maghrib: parseTime(json['Maghrib']),
      isha: parseTime(json['Isha']),
    );
  }

}

class StartUp extends StatefulWidget {
  const StartUp({super.key});

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final email = prefs.getString('email');

    return {
      'username': username,
      'email': email,
    };
  }
  // PrayerTimes getPrayerTime() {
  //   final myCoordinates = Coordinates(30.033333, 31.233334);
  //   final params = CalculationMethod.egyptian.getParameters();
  //   params.madhab = Madhab.shafi;
  //   final prayerTimes = PrayerTimes.today(myCoordinates, params);
  //   return prayerTimes;
  // }
  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }
  final DatabaseHelper dbHelper = DatabaseHelper();
  PrayerCurrent? prayerCurrent;
  Timer? _timer;
  Duration _timeRemaining = Duration();
  String _nextPrayer = "";
  PrayerTimes? _prayerTimes;
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
  void _getPrayerDataCurrent() async {
    prayerCurrent = await dbHelper.getPrayerCurrent(_formatDate(selectedDate));
    prayerCurrent ??= PrayerCurrent(
      day: formattedDate,
      prayer1: false,
      prayer2: false,
      prayer3: false,
      prayer4: false,
      prayer5: false,
      prayer6: false,
      prayer7: false,
      prayer8: false,
      prayer9: false,
      prayer10: false,
      prayer11: false,
      calculation: 0,
    );
    setState(() {});
  }

  Future<void> _fetchPrayerTimes() async {
    final response = await http.get(Uri.parse('https://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=5'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['timings'];
      setState(() {
        _prayerTimes = PrayerTimes.fromJson(data);
        _startCountdown();
      });
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  void _startCountdown() {
    DateTime now = DateTime.now();
    DateTime? nextPrayerTime;

    if (now.isBefore(_prayerTimes!.fajr)) {
      nextPrayerTime = _prayerTimes!.fajr;
      _nextPrayer = "الفجر";
    } else if (now.isBefore(_prayerTimes!.dhuhr)) {
      nextPrayerTime = _prayerTimes!.dhuhr;
      _nextPrayer = "الظهر";
    } else if (now.isBefore(_prayerTimes!.asr)) {
      nextPrayerTime = _prayerTimes!.asr;
      _nextPrayer = "العصر";
    } else if (now.isBefore(_prayerTimes!.maghrib)) {
      nextPrayerTime = _prayerTimes!.maghrib;
      _nextPrayer = "المغرب";
    } else if (now.isBefore(_prayerTimes!.isha)) {
      nextPrayerTime = _prayerTimes!.isha;
      _nextPrayer = "العشاء";
    } else {
      nextPrayerTime = _prayerTimes!.fajr.add(const Duration(days: 1));
      _nextPrayer = "الفجر";
    }

    // Check if the adjusted time is still in the future
    if (now.isAfter(nextPrayerTime)) {
      // If the adjusted time has passed, skip to the next prayer
      _skipToNextPrayer(now);
    } else {
      _setTimer(nextPrayerTime, now);
    }
    // scheduleNotification(nextPrayerTime,_nextPrayer);

  }

  void _skipToNextPrayer(DateTime now) {
    // Loop through prayers and find the first one that's in the future
    DateTime? nextPrayerTime;

    if (now.isBefore(_prayerTimes!.dhuhr)) {
      nextPrayerTime = _prayerTimes!.dhuhr;
      _nextPrayer = "الضهر";
    } else if (now.isBefore(_prayerTimes!.asr)) {
      nextPrayerTime = _prayerTimes!.asr;
      _nextPrayer = "العصر";
    } else if (now.isBefore(_prayerTimes!.maghrib)) {
      nextPrayerTime = _prayerTimes!.maghrib;
      _nextPrayer = "المغرب";
    } else if (now.isBefore(_prayerTimes!.isha)) {
      nextPrayerTime = _prayerTimes!.isha;
      _nextPrayer = "العشاء";
    } else {
      nextPrayerTime = _prayerTimes!.fajr.add(Duration(days: 1));
      _nextPrayer = "الفجر";
    }

    _setTimer(nextPrayerTime, now);
  }

  void _setTimer(DateTime nextPrayerTime, DateTime now) {
    setState(() {
      _timeRemaining = nextPrayerTime.difference(now);
    });

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _timeRemaining = nextPrayerTime.difference(DateTime.now());
        if (_timeRemaining.isNegative) {
          _timer!.cancel();
          _fetchPrayerTimes();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getPrayerDataCurrent();
    _fetchPrayerTimes();
  }
  void _updateCalculation(BuildContext context) {
    final provider = Provider.of<PrayerProvider>(context, listen: false);
    final prayer = provider.prayerCurrentData!;
    int count = 0;
    if (prayer.prayer1) count++;
    if (prayer.prayer2) count++;
    if (prayer.prayer3) count++;
    if (prayer.prayer4) count++;
    if (prayer.prayer5) count++;
    if (prayer.prayer6) count++;
    if (prayer.prayer7) count++;
    if (prayer.prayer8) count++;
    if (prayer.prayer9) count++;
    if (prayer.prayer10) count++;
    if (prayer.prayer11) count++;
    prayer.calculation = count;
    provider.updatePrayerCurrent(prayer);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bool value = context.watch<BoolNotifier>().value1;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, Get.height * .23),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),
              Image.asset(
                'images/Rectangle 1.png',
                fit: BoxFit.fitWidth,
                width: Get.width,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final userData = await getUserData();

                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: Profile(
                                      username: '${userData['username']}',
                                      email: '${userData['email']}',
                                    ),
                                    withNavBar:
                                        true, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );

                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'icons/img_1.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const Settings(),
                              withNavBar:
                                  true, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            child: Image.asset(
                              'icons/img.png',
                              width: 20,
                              height: 20,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _prayerTimes == null ? const Expanded(child:CircularProgressIndicator()) :Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:  Text(
                        'الأذان القادم صلاه $_nextPrayer',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    _prayerTimes == null ? const Expanded(child:CircularProgressIndicator()) :Expanded(
                      child: Text(
                        '${_timeRemaining.inHours.remainder(24).toString().padLeft(2, '0')}:${_timeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
      body: Consumer<PrayerProvider>(builder: (context, provider, child) {
        final prayer = provider.prayerCurrentData ??
            PrayerCurrent(
              day: _formatDate(selectedDate),
              prayer1: false,
              prayer2: false,
              prayer3: false,
              prayer4: false,
              prayer5: false,
              prayer6: false,
              prayer7: false,
              prayer8: false,
              prayer9: false,
              prayer10: false,
              prayer11: false,
              calculation: 0,
            );
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/back ground.jpeg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(1),
                color: Colors.white,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical:10),
                    alignment: Alignment.topRight,
                    child: Text(
                      'الصلوات اليومية',
                      style: TextStyle(
                          letterSpacing: .6,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  value == true
                      ? Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    context
                                        .read<BoolNotifier>()
                                        .setValue1(false);
                                  },
                                  child: Text(
                                    'اعادة التشغيل',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        color: buttonColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                alignment: Alignment.center,
                                width: Get.width * .23,
                                height: Get.height * .043,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                          color: buttonColor,
                                          blurRadius: 1,
                                          spreadRadius: .5)
                                    ]),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'تم تفعيل وضع ايقاف الصلاه والصيام',
                                      style: TextStyle(
                                          letterSpacing: .6,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          width: Get.width * .95,
                          height: Get.height * .1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: .5)
                              ]),
                        )
                      : Column(
                          children: [
                            SlahBox(
                              'الفجر',
                              _prayerTimes == null ? "" :
                              _formatTime(_prayerTimes!.fajr).replaceAll('AM', "ص"),
                              "images/Illustrator.png",
                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(width: 1.0, color:buttonColor),
                                    ),
                                    activeColor: buttonColor,
                                    checkColor: Colors.white,
                                    value: prayer.prayer2,
                                    onChanged: (value) {

                                        prayer.prayer2 = value!;
                                        _updateCalculation(context);
                                    }),
                              ),
                            ),
                            SlahBox(
                              'الظهر',
                              _prayerTimes == null ? "" :
                              _formatTime(_prayerTimes!.dhuhr).replaceAll('PM', "م"),
                              "images/1.png",
        Transform.scale(
        scale: 1.3,
        child:Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color:buttonColor),
            ),
                                  activeColor: buttonColor,
                                  checkColor: Colors.white,
                                  value: prayer.prayer5,
                                  onChanged: (value) {

                                      prayer.prayer5 = value!;
                                      _updateCalculation(context);

                                  }),
                            ),
                            ),
                            SlahBox(
                              'العصر',
                              _prayerTimes == null ? "" :
                              _formatTime(_prayerTimes!.asr).replaceAll('PM', "م"),
                              "images/Illustrator (1).png",
        Transform.scale(
        scale: 1.3,
        child:  Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color:buttonColor),
            ),
                                  activeColor: buttonColor,
                                  checkColor: Colors.white,
                                  value: prayer.prayer6,
                                  onChanged: (value) {

                                      prayer.prayer6 = value!;
                                      _updateCalculation(context);

                                  }),
                            ),),
                            SlahBox(
                                'المغرب',
                                _prayerTimes == null ? "" :
                                _formatTime(_prayerTimes!.maghrib).replaceAll('PM', "م"),
                                "icons/Illustrator.png",
        Transform.scale(
        scale: 1.3,
        child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color:buttonColor),
            ),        activeColor: buttonColor,
                                    checkColor: Colors.white,
                                    value: prayer.prayer8,
                                    onChanged: (value) {
                                      // if (FirebaseAuth.instance.currentUser ==
                                      //     null) {
                                      //   Get.defaultDialog(
                                      //       content: GestureDetector(
                                      //         onTap: () {
                                      //           Get.to(SignInView());
                                      //         },
                                      //         child: Container(
                                      //           alignment: Alignment.center,
                                      //           width: 200,
                                      //           height: 50,
                                      //           color: buttonColor,
                                      //           child: Text(
                                      //             'تسجيل الدخول',
                                      //             style: TextStyle(
                                      //                 color: Colors.white,
                                      //                 fontSize: 18),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       title:
                                      //       '"لا يمكن حفظ المعلومات", "لحفظ المعلومات برجاء تسجيل الدخول"',
                                      //       backgroundColor: Colors.white);
                                      // }else {
                                        prayer.prayer8 = value!;
                                        _updateCalculation(context);

                                    })),
                            ),
                            SlahBox(
                                'العشاء',
                                _prayerTimes == null ? "":
                                _formatTime(_prayerTimes!.isha).replaceAll('PM', "م"),
                                "images/Illustrator (2).png",
        Transform.scale(
        scale: 1.3,
        child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color:buttonColor),
            ),
                                    activeColor: buttonColor,
                                    checkColor: Colors.white,
                                    value: prayer.prayer10,
                                    onChanged: (value) {
                                      // if (FirebaseAuth.instance.currentUser ==
                                      //     null) {
                                      //   Get.defaultDialog(
                                      //       content: GestureDetector(
                                      //         onTap: () {
                                      //           Get.to(SignInView());
                                      //         },
                                      //         child: Container(
                                      //           alignment: Alignment.center,
                                      //           width: 200,
                                      //           height: 50,
                                      //           color: buttonColor,
                                      //           child: Text(
                                      //             'تسجيل الدخول',
                                      //             style: TextStyle(
                                      //                 color: Colors.white,
                                      //                 fontSize: 18),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       title:
                                      //       '"لا يمكن حفظ المعلومات", "لحفظ المعلومات برجاء تسجيل الدخول"',
                                      //       backgroundColor: Colors.white);
                                      // }else {
                                        prayer.prayer10 = value!;
                                        _updateCalculation(context);

                                    })),)
                          ],
                        ),

                  TextButton(
                    onPressed: () {},
                    child: TextButton(
                      onPressed: () {
                        // if (FirebaseAuth.instance.currentUser ==
                        //     null) {
                        //   Get.defaultDialog(
                        //       content: GestureDetector(
                        //         onTap: () {
                        //           Get.to(SignInView());
                        //         },
                        //         child: Container(
                        //           alignment: Alignment.center,
                        //           width: 200,
                        //           height: 50,
                        //           color: buttonColor,
                        //           child: Text(
                        //             'تسجيل الدخول',
                        //             style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 18),
                        //           ),
                        //         ),
                        //       ),
                        //       title:
                        //       '"لا يمكن عرض الاهداف", "لحفظ المعلومات برجاء تسجيل الدخول"',
                        //       backgroundColor: Colors.white);
                        // } else {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const DailyGoals(),
                            withNavBar:
                                true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );

                      },
                      child: Text(

                        textDirection: TextDirection.rtl,
                        'عرض باقي اهداف اليوم',
                        style: GoogleFonts.almarai(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: buttonColor,

                        )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                    alignment: Alignment.topRight,
                    child: Text(
                      textDirection: TextDirection.rtl,
                      'يمكنك ايضا تصفح باقي المزايا',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: Qiblah(),
                            withNavBar:
                                true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Image.asset("images/Group (1).png"),
                              Text(
                                'القبلة',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          ),
                          width: Get.width * .28,
                          height: Get.height * .1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: .5)
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const Roqua(),
                            withNavBar:
                                true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Image.asset("images/Group.png"),
                              Text(
                                'الرقيه الشرعيه',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          ),
                          width: Get.width * .28,
                          height: Get.height * .1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: .5)
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: SibhaView(),
                            withNavBar:
                                true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Image.asset("images/noto_prayer-beads.png"),
                              Text(
                                'السبحة',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          ),
                          width: Get.width * .28,
                          height: Get.height * .1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: .5)
                              ]),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget SlahBox(text, time, icn, chkbox) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: Get.width * .95,
      height: Get.height * .06,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: .5)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          chkbox,
          Text(
            textDirection: TextDirection.rtl,
            '$time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                textDirection: TextDirection.rtl,
                '$text',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: Get.width * .02,
              ),
              Image.asset(icn)
            ],
          )
        ],
      ),
    );
  }
}
