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
import 'package:prayer_app/view/home/nav_bar_screens/qiblah.dart';
import 'package:intl/intl.dart' as intl;
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
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final userData = await getUserData();
                              Get.to(Profile(
                                username: '${userData['username']}',
                                email: '${userData['email']}',
                              ));
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
                          // CircleAvatar(
                          //   child: Icon(Icons.notifications_none),
                          //   backgroundColor: Colors.grey.shade400,
                          //   radius: 20,
                          // ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const Settings());
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
                  height: Get.height * 0.04,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'images/back ground2.jpeg',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'الأذان القادم صلاه ${salahName[_prayerTimeCalculator.salahCalc]}',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textDirection: TextDirection.rtl,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
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
                                  .replaceAll('AM', "ص")),
                          SlahBox(
                              'الظهر',
                              (intl.DateFormat.jm()
                                  .format(getPrayerTime().dhuhr))
                                  .replaceAll('PM', "م")),
                          SlahBox('العصر',
                              (intl.DateFormat.jm()
                                  .format(getPrayerTime().asr))
                                  .replaceAll('PM', "م")),
                          SlahBox(
                              'المغرب',
                              (intl.DateFormat.jm()
                                  .format(getPrayerTime().maghrib))
                                  .replaceAll('PM', "م")),
                          SlahBox(
                              'العشاء',
                              (intl.DateFormat.jm()
                                  .format(getPrayerTime().isha))
                                  .replaceAll('PM', "م")),
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
                            Icon(
                              FlutterIslamicIcons.solidQibla2,
                              color: Colors.blue[900],
                            ),
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
                            Icon(
                              FlutterIslamicIcons.quran,
                              color: Colors.blue[900],
                            ),
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
                            Icon(
                              FlutterIslamicIcons.solidTasbih2,
                              color: Colors.blue[900],
                            ),
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

  Widget SlahBox(text, time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Checkbox(value: false, onChanged: (_) {}),
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
              Icon(
                Icons.sunny_snowing,
                color: Colors.blue[900],
              )
            ],
          )
        ],
      ),
      width: Get.width * .95,
      height: Get.height * .06,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: .5)
          ]),
    );
  }
}
