import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/PrayerTimeCalculator.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModel.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModelCurrent.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/sqlite/database_helper.dart';
import 'package:prayer_app/view/home/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../provider/prayer_provider.dart';
import '../../auth/sign_in_view.dart';
import '../profile.dart';
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
class Prayer extends StatefulWidget {
  const Prayer({super.key});

  @override
  State<Prayer> createState() => _PrayerState();
}


class _PrayerState extends State<Prayer> with TickerProviderStateMixin {
  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final email = prefs.getString('email');

    return {
      'username': username,
      'email': email,
    };
  }
  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }
  final DatabaseHelper dbHelper = DatabaseHelper();
  DateTime selectedDate = DateTime.now().subtract(const Duration(days:1));
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
   List<int> salahHours = [];
   List<int> salahMin = [];
   List<String> salahName = ["الفجر","الضهر", "العصر","المغرب","العشاء"];
  PrayerCurrent? prayerCurrent;
  late TabController _controller;
  Timer? _timer;
  Duration _timeRemaining = Duration();
  String _nextPrayer = "";
  PrayerTimes? _prayerTimes;
  Future<void> _fetchPrayerTimes() async {
    try{
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
    }catch(e){
      debugPrint('Exception $e');
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
  }

  void _skipToNextPrayer(DateTime now) {
    // Loop through prayers and find the first one that's in the future
    DateTime? nextPrayerTime;

    if (now.isBefore(_prayerTimes!.dhuhr)) {
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
  void initState(){
    super.initState();
    _getPrayerDataCurrent();
    _fetchPrayerTimes();
    _controller = TabController(
        initialIndex: 1, length: 2, vsync: this);
  }
  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
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
  void _savePrayerDataCurrent() async {
    if (prayerCurrent != null) {
      await dbHelper.insertPrayerCurrent(prayerCurrent!);
    }
  }
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await  showDatePicker(
      context: context,
      initialDate: selectedDate,
       firstDate: DateTime(2000),
      lastDate: DateTime.now().subtract(const Duration(days:1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: buttonColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: buttonColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: buttonColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    // showDatePicker(
    //   context: context,
    //   initialDate: selectedDate,
    //   firstDate: DateTime(2000),
    //   lastDate: DateTime.now(),
    // );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _getPrayerDataCurrent();
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<PrayerProvider>(
          builder: (context, provider, child) {
            // provider.getAllLastPrayers();
            final prayer = provider.prayerCurrentData!;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/back ground.jpeg'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final userData = await getUserData();
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
                                  // }else{
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen:  Profile(username: '${userData['username']}',
                                        email: '${userData['email']}',),
                                      withNavBar: true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );

                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.shade400,
                                  child: Image.asset(
                                    'icons/img_1.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const Settings(),
                                    withNavBar: true,
                                    // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation: PageTransitionAnimation
                                        .cupertino,
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  child: Image.asset(
                                    'icons/img.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  backgroundColor: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .03,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/back ground2.jpeg',
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _prayerTimes == null ? const  CircularProgressIndicator() :Container(
                              alignment: Alignment.center,
                              child:  Text(
                                'الأذان القادم صلاه $_nextPrayer',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ),
                            _prayerTimes == null ? const  CircularProgressIndicator() :Text(
                              '${_timeRemaining.inHours.remainder(24).toString().padLeft(2, '0')}:${_timeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),

                    TabBar(
                      labelStyle: const TextStyle(fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      indicatorColor: Colors.blue[900],
                      labelColor: Colors.blue[900],
                      controller: _controller,
                      tabs: [
                        Tab(
                          text: "الصلوات الفائته",
                        ),
                        Tab(
                          text: "الصلوات اليوميه",
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        height: Get.height,
                        child: TabBarView(
                          controller: _controller,
                          children: <Widget>[
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      customCard("${provider.ishaMissed}", "عشاء"),
                                      customCard("${provider.maghribMissed}", "مغرب"),
                                      customCard("${provider.asrMissed}", "عصر"),
                                      customCard("${provider.dhuhrMissed}", "ضهر"),
                                      customCard("${provider.fajrMissed}", "فجر"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.date_range_outlined),
                                        color: Colors.blue[900],
                                        onPressed: () => _selectDate(context),
                                      ),
                                      const Text("حدد يوم", style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                                prayerCurrent == null
                                    ? const Center(
                                    child: CircularProgressIndicator())
                                    : customSalah("الفجر",
                                    Transform.scale(
                                      scale: 1.3,
                                      child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2.0),
                                      ),
                                      side: MaterialStateBorderSide.resolveWith(
                                            (states) => BorderSide(width: 1.0, color:buttonColor),
                                      ),
                                                                        //tristate: true,
                                      activeColor: Colors.blue[900],
                                      value: prayerCurrent == null
                                          ? false
                                          : prayerCurrent!.prayer2,
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
                                        // }else{
                                          setState(() {
                                            prayerCurrent!.prayer2 = value!;
                                          });
                                          _savePrayerDataCurrent();

                                      }),
                                    )),
                                customSalah("الضهر",

            Transform.scale(
            scale: 1.3,
            child:
                                    Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(width: 1.0, color:buttonColor),
                                    ),
                                  //tristate: true,
                                    activeColor: Colors.blue[900],
                                    value: prayerCurrent == null
                                        ? false
                                        : prayerCurrent!.prayer5,
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
                                      // }else{
                                        setState(() {
                                          prayerCurrent!.prayer5 = value!;
                                        });
                                        _savePrayerDataCurrent();


                                    }))),
                                customSalah("العصر",


            Transform.scale(
            scale: 1.3,
            child:
                                    Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(width: 1.0, color:buttonColor),
                                    ),
                                  //tristate: true,
                                    activeColor: Colors.blue[900],
                                    value: prayerCurrent == null
                                        ? false
                                        : prayerCurrent!.prayer6,
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
                                      // }else{
                                        setState(() {
                                          prayerCurrent!.prayer6 = value!;
                                        });
                                        _savePrayerDataCurrent();

                                    }))),
                                customSalah("المغرب",
            Transform.scale(
            scale: 1.3,
            child:
                                    Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(width: 1.0, color:buttonColor),
                                    ),
                                  //tristate: true,
                                    activeColor: Colors.blue[900],
                                    value: prayerCurrent == null
                                        ? false
                                        : prayerCurrent!.prayer8,
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
                                      // }else{
                                        setState(() {
                                          prayerCurrent!.prayer8 = value!;
                                        });
                                        _savePrayerDataCurrent();

                                    }))),
                                customSalah("العشاء",
            Transform.scale(
            scale: 1.3,
            child:
                                    Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(width: 1.0, color:buttonColor),
                                    ),
                                  //tristate: true,
                                    activeColor: Colors.blue[900],
                                    value: prayerCurrent == null
                                        ? false
                                        : prayerCurrent!.prayer10,
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
                                      // }else{
                                        setState(() {
                                          prayerCurrent!.prayer10 = value!;
                                        });
                                        _savePrayerDataCurrent();

                                    }))),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.date_range_outlined,
                                          color: Colors.blue[900],
                                        ),
                                        Text(
                                          formattedDate,
                                        ),
                                        Text(
                                          "اليوم",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: LinearProgressBar(
                                              maxSteps: 5,
                                              minHeight: 8,
                                              progressType:
                                              LinearProgressBar
                                                  .progressTypeLinear,
                                              // Use Linear progress
                                              currentStep: prayer == null
                                                  ? 0
                                                  : prayer.calculation,
                                              progressColor: Colors.blue[900],
                                              backgroundColor: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'فروض اليوم',
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(children: [
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
                                              value: prayer.prayer1,
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
                                                // }else{
                                                  prayer.prayer1 = value!;


                                              })),
                                          Text(
                                            'النافله',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
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
                                                // }else{
                                                  prayer.prayer2 = value!;
                                                  _updateCalculation(context);

                                              }
                                              )),
                                          Text(
                                            'الفرض',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(
                                          children: [
                                            Text(
                                              'الفجر',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.sunny_snowing)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(children: [
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
                                              value: prayer.prayer3,
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
                                                // }else{
                                                  prayer.prayer3 = value!;

                                              }),
            )]),
                                        Row(
                                          children: [
                                            Text(
                                              'الضحي',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.sunny_snowing)
                                          ],
                                        ),
                                      ],
                                    ),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(children: [
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
                                              value: prayer.prayer4,
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
                                                // }else{
                                                  prayer.prayer4 = value!;

                                              })),
                                          Text(
                                            'النافلة',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
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
                                              value: prayer.prayer5,
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
                                                // }else{
                                                  prayer.prayer5 = value!;
                                                  _updateCalculation(context);

                                              })),
                                          Text(
                                            'الفرض',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(
                                          children: [
                                            Text(
                                              'الضهر',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.sunny_snowing)
                                          ],
                                        ),
                                      ],
                                    ),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(children: [
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
                                                // }else{
                                                  prayer.prayer6 = value!;
                                                  _updateCalculation(context);

                                              })),
                                          Text(
                                            'الفرض',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(
                                          children: [
                                            Text(
                                              'العصر',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.sunny_snowing)
                                          ],
                                        ),
                                      ],
                                    ),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(children: [
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
                                              value: prayer.prayer7,
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
                                                // }else{
                                                  prayer.prayer7 = value!;


                                              })),
                                          Text(
                                            'النافلة',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
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
                                                // }else{
                                                  prayer.prayer8 = value!;
                                                  _updateCalculation(context);

                                              }),),
                                          Text(
                                            'الفرض',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(
                                          children: [
                                            Text(
                                              'المغرب',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.sunny_snowing)
                                          ],
                                        ),
                                      ],
                                    ),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(children: [
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
                                              value: prayer.prayer9,
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
                                                // }else{
                                                  prayer.prayer9 = value!;


                                              })),
                                          Text(
                                            'النافلة',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
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
                                                // }else{
                                                  prayer.prayer10 = value!;
                                                  _updateCalculation(context);

                                              })),
                                          Text(
                                            'الفرض',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        Row(
                                          children: [
                                            Text(
                                              'العشاء',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.sunny_snowing)
                                          ],
                                        ),
                                      ],
                                    ),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(children: [
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
                                              value: prayer.prayer11,
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
                                                // }else{
                                                  prayer.prayer11 = value!;


                                              }),
            )]),
                                        Row(
                                          children: [
                                            Text(
                                              'القيام',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.sunny_snowing)
                                          ],
                                        ),
                                      ],
                                    ),
                                    width: Get.width * .95,
                                    height: Get.height * .06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 1,
                                              spreadRadius: .5)
                                        ]),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        ));
  }

  Widget customCard(num,text){
    return SizedBox(
      height: 60,
      width: 60,
      child: Card(
        color: Colors.blue[900],
        child: Center(
          child: Column(
            children: [
              Text(num,style: TextStyle(color: Colors.white,fontSize: 17),),
              Text(text,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
  Widget customSalah(text,var chkBox){
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween,
        children: [
          chkBox,
          Text(
            '${_formatDate(selectedDate)}',
            style: TextStyle(
              fontSize: 17,

            ),
          ),
          Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        ],
      ),
      width: Get.width * .95,
      height: Get.height * .06,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
                spreadRadius: .5)
          ]),
    );
  }
}
