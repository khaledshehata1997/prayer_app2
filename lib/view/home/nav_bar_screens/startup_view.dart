import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:prayer_app/view/home/dailyGoals.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/PrayerTimeCalculator.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModel.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/sqlite/database_helper.dart';
import 'package:prayer_app/view/home/nav_bar_screens/qiblah.dart';
import 'package:intl/intl.dart' as intl;
import 'package:prayer_app/view/home/nav_bar_screens/quran/core/utils/assets_manager.dart';
import 'package:prayer_app/view/home/profile.dart';
import 'package:prayer_app/view/home/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../provider/boolNotifier.dart';
import '../../roqua_view.dart';
import '../../sibha/sibha_view.dart';

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
  final DatabaseHelper dbHelper = DatabaseHelper();
  PrayerModel? prayerData;
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
  void _savePrayerData() async {
    if (prayerData != null) {
      await dbHelper.insertPrayer(prayerData!);
    }
  }
  void _getPrayerData() async {
    prayerData = await dbHelper.getPrayer(_formatDate(selectedDate));
    if (prayerData == null) {
      prayerData = PrayerModel(
        day: _formatDate(selectedDate),
        prayer1: false,
        prayer2: false,
        prayer3: false,
        prayer4: false,
        prayer5: false,
      );
    }
    setState(() {});
  }

  List<String> salahName = ["الفجر", "الضهر", "العصر", "المغرب", "العشاء"];
  late PrayerTimeCalculator _prayerTimeCalculator;
  late DateTime _nextPrayerTime;
  late Timer _timer;
  int nxtDay = 0;
  List<int> salahHours = [];
  List<int> salahMin = [];

  @override
  void initState() {
    super.initState();
    _getPrayerData();
    _salah();
    _prayerTimeCalculator = PrayerTimeCalculator();
    _nextPrayerTime = DateTime(
      _prayerTimeCalculator.currentTime.year,
      _prayerTimeCalculator.currentTime.month,
      _prayerTimeCalculator.currentTime.day,
      salahHours[_prayerTimeCalculator.salahCalc],
      salahMin[_prayerTimeCalculator.salahCalc],
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _prayerTimeCalculator.updateCurrentTime();
      });
      Duration difference = _nextPrayerTime.difference(DateTime.now());
      if (difference.isNegative ||
          difference.inSeconds == 0 ||
          difference.inHours >= 8) {
        _timer.cancel();
        if (_prayerTimeCalculator.salahCalc == 4) {
          setState(() {
            _prayerTimeCalculator.salahCalc = 0;
          });
        } else if (_prayerTimeCalculator.salahCalc == 0 &&
            _prayerTimeCalculator.currentTime.isAfter(_nextPrayerTime)) {
          nxtDay++;
        } else {
          setState(() {
            _prayerTimeCalculator.salahCalc++;
          });
        }
        _nextPrayerTime = DateTime(
          _prayerTimeCalculator.currentTime.year,
          _prayerTimeCalculator.currentTime.month,
          _prayerTimeCalculator.currentTime.day + nxtDay,
          salahHours[_prayerTimeCalculator.salahCalc],
          salahMin[_prayerTimeCalculator.salahCalc],
        );
        nxtDay = 0;
        _startTimer();
      }
    });
  }

  PrayerTimes getPrayerTime() {
    final myCoordinates = Coordinates(30.033333, 31.233334);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);
    return prayerTimes;
  }

  void _salah() {
    salahHours.add(int.parse(DateFormat.jm().format(getPrayerTime().fajr)[0]));
    salahHours
        .add(int.parse(DateFormat.jm().format(getPrayerTime().dhuhr)[0]) + 12);
    salahHours
        .add(int.parse(DateFormat.jm().format(getPrayerTime().asr)[0]) + 12);
    salahHours.add(
        int.parse(DateFormat.jm().format(getPrayerTime().maghrib)[0]) + 12);
    salahHours
        .add(int.parse(DateFormat.jm().format(getPrayerTime().isha)[0]) + 12);
    salahMin.add(int.parse(
        DateFormat.jm().format(getPrayerTime().fajr).substring(2, 4)));
    salahMin.add(int.parse(
        DateFormat.jm().format(getPrayerTime().dhuhr).substring(3, 4)));
    salahMin.add(
        int.parse(DateFormat.jm().format(getPrayerTime().asr).substring(2, 4)));
    salahMin.add(int.parse(
        DateFormat.jm().format(getPrayerTime().maghrib).substring(2, 4)));
    salahMin.add(int.parse(
        DateFormat.jm().format(getPrayerTime().isha).substring(2, 4)));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool value = context.watch<BoolNotifier>().value1;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, Get.height * .30),
          // here the desired height
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
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 5),
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
                                Get.off(Profile(
                                  username: '${userData['username']}',
                                  email: '${userData['email']}',
                                ));
                              },
                              child: CircleAvatar(
                                radius: 15,
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
                            Get.to(const Settings());
                          },
                          child: CircleAvatar(
                            radius: 15,
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
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'الأذان القادم صلاه ${salahName[_prayerTimeCalculator.salahCalc]}',
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
      body: Stack(
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
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                                  context.read<BoolNotifier>().setValue1(false);
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
                              (intl.DateFormat.jm()
                                      .format(getPrayerTime().fajr))
                                  .replaceAll('AM', "ص"),"images/Illustrator.png",Checkbox(
                            //tristate: true,
                              activeColor: Colors.blue[900],
                              value: prayerData == null ? false : prayerData!.prayer1,
                              onChanged: (value){
                                setState(() {
                                  prayerData!.prayer1 = value!;
                                });
                                _savePrayerData();
                              })),
                          SlahBox(
                              'الظهر',
                              (intl.DateFormat.jm()
                                      .format(getPrayerTime().dhuhr))
                                  .replaceAll('PM', "م"),"images/1.png",Checkbox(
                            //tristate: true,
                              activeColor: Colors.blue[900],
                              value: prayerData == null ? false : prayerData!.prayer2,
                              onChanged: (value){
                                setState(() {
                                  prayerData!.prayer2 = value!;
                                });
                                _savePrayerData();
                              })),
                          SlahBox(
                              'العصر',
                              (intl.DateFormat.jm().format(getPrayerTime().asr))
                                  .replaceAll('PM', "م"),"images/Union (1).png",Checkbox(
                            //tristate: true,
                              activeColor: Colors.blue[900],
                              value: prayerData == null ? false : prayerData!.prayer3,
                              onChanged: (value){
                                setState(() {
                                  prayerData!.prayer3 = value!;
                                });
                                _savePrayerData();
                              })),
                          SlahBox(
                              'المغرب',
                              (intl.DateFormat.jm()
                                      .format(getPrayerTime().maghrib))
                                  .replaceAll('PM', "م"),"images/Illustrator (2).png",Checkbox(
                            //tristate: true,
                              activeColor: Colors.blue[900],
                              value: prayerData == null ? false : prayerData!.prayer4, onChanged: (value){
                            setState(() {
                              prayerData!.prayer4 = value!;
                            });
                            _savePrayerData();
                          })),
                          SlahBox(
                              'العشاء',
                              (intl.DateFormat.jm()
                                      .format(getPrayerTime().isha))
                                  .replaceAll('PM', "م"),"images/Illustrator (1).png",Checkbox(
                            //tristate: true,
                              activeColor: Colors.blue[900],
                              value: prayerData == null ? false : prayerData!.prayer5,
                              onChanged: (value){
                                setState(() {
                                  prayerData!.prayer5 = value!;
                                });
                                _savePrayerData();
                              })),
                        ],
                      ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                TextButton(
                  onPressed: () {},
                  child: TextButton(
                    onPressed: () {
                      Get.to(const DailyGoals());
                    },
                    child: Text(
                      textDirection: TextDirection.rtl,
                      'عرض باقي اهداف اليوم',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: buttonColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
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
                        Get.to(Qiblah());
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
                        height: Get.height * .08,
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
                        Get.to(const Roqua());
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
                        height: Get.height * .08,
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
                        Get.to(SibhaView());
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
                        height: Get.height * .08,
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
      ),
    );
  }

  Widget SlahBox(text, time,icn,chkbox) {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Image.asset(
                icn
              )
            ],
          )
        ],
      ),
    );
  }
}
