import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/PrayerTimeCalculator.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModel.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModelCurrent.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/sqlite/database_helper.dart';
import '../../../constants.dart';

class Prayer extends StatefulWidget {
  const Prayer({super.key});

  @override
  State<Prayer> createState() => _PrayerState();
}

late PrayerTimeCalculator _prayerTimeCalculator;
late DateTime _nextPrayerTime;
late Timer _timer;
 int nxtDay = 0;
class _PrayerState extends State<Prayer> with TickerProviderStateMixin {

  final DatabaseHelper dbHelper = DatabaseHelper();
  PrayerModel? prayerData;
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
   List<int> salahHours = [];
   List<int> salahMin = [];
   List<String> salahName = ["الفجر","الضهر", "العصر","المغرب","العشاء"];
  PrayerCurrent? prayerCurrent;
  static int _index = 0;
  late TabController _controller;
  @override
  void initState(){
    super.initState();
    _salah();
    _getPrayerData();
    _getPrayerDataCurrent();
    _prayerTimeCalculator = PrayerTimeCalculator();
    _nextPrayerTime = DateTime(
      _prayerTimeCalculator.currentTime.year,
      _prayerTimeCalculator.currentTime.month,
      _prayerTimeCalculator.currentTime.day + nxtDay,
      salahHours[_prayerTimeCalculator.salahCalc],
      salahMin[_prayerTimeCalculator.salahCalc],
    );
    if (_prayerTimeCalculator.currentTime.isAfter(_nextPrayerTime)&& _nextPrayerTime.difference(DateTime.now()).isNegative) {
     nxtDay++;
    }
    _startTimer();
    _controller = TabController(
        initialIndex: _PrayerState._index, length: 2, vsync: this);
  }
  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
  PrayerTimes getPrayerTime(){
    final myCoordinates = Coordinates(30.033333, 31.233334);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);
    return prayerTimes;
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _prayerTimeCalculator.updateCurrentTime();
      });
      Duration difference = _nextPrayerTime.difference(DateTime.now());
      if (difference.isNegative || difference.inSeconds == 0 || difference.inHours >= 9) {
        _timer.cancel();
        print("cancel");
        if(_prayerTimeCalculator.salahCalc == 4){
          setState(() {
            _prayerTimeCalculator.salahCalc = 0;
            print(_prayerTimeCalculator.salahCalc.toString());
          });

        }else{
          setState(() {
            _prayerTimeCalculator.salahCalc++;
            print(_prayerTimeCalculator.salahCalc.toString());
          });

        }
        _nextPrayerTime = DateTime(
          _prayerTimeCalculator.currentTime.year,
          _prayerTimeCalculator.currentTime.month,
          _prayerTimeCalculator.currentTime.day,
          salahHours[_prayerTimeCalculator.salahCalc],
          salahMin[_prayerTimeCalculator.salahCalc],
        );
        _startTimer();
      }

    });
  }
  void _salah(){
    salahHours.add(int.parse(DateFormat.jm().format(getPrayerTime().fajr)[0]));
    salahHours.add(int.parse(DateFormat.jm().format(getPrayerTime().dhuhr)[0]) + 12);
    salahHours.add(int.parse(DateFormat.jm().format(getPrayerTime().asr)[0]) + 12);
    salahHours.add(int.parse(DateFormat.jm().format(getPrayerTime().maghrib)[0]) + 12);
    salahHours.add(int.parse(DateFormat.jm().format(getPrayerTime().isha)[0]) + 12);
    salahMin.add(int.parse(DateFormat.jm().format(getPrayerTime().fajr).substring(2,4)));
    salahMin.add(int.parse(DateFormat.jm().format(getPrayerTime().dhuhr).substring(2,4)));
    salahMin.add(int.parse(DateFormat.jm().format(getPrayerTime().asr).substring(2,4)));
    salahMin.add(int.parse(DateFormat.jm().format(getPrayerTime().maghrib).substring(2,4)));
    salahMin.add(int.parse(DateFormat.jm().format(getPrayerTime().isha).substring(2,4)));
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
  void _getPrayerDataCurrent() async {
    prayerCurrent = await dbHelper.getPrayerCurrent(_formatDate(selectedDate));
    if (prayerCurrent == null) {
      print("get");
    prayerCurrent = PrayerCurrent(
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
  }
    setState(() {});
  }
  void _savePrayerDataCurrent() async {
    if (prayerCurrent != null) {
      await dbHelper.insertPrayerCurrent(prayerCurrent!);
    }
  }
  void _savePrayerData() async {
    if (prayerData != null) {
      await dbHelper.insertPrayer(prayerData!);
    }
  }
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _getPrayerData();
    }
  }
  @override
  Widget build(BuildContext context) {
    Duration timeLeft = _prayerTimeCalculator.timeLeftForNextPrayer(_nextPrayerTime);
    return Scaffold(
        body: Stack(
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
                  height: Get.height * .02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade400,
                            child: Image.asset(
                              'icons/img_1.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            child: Icon(Icons.notifications_none),
                            backgroundColor: Colors.grey.shade400,
                            radius: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CircleAvatar(
                            radius: 20,
                            child: Image.asset(
                              'icons/img.png',
                              width: 20,
                              height: 20,
                            ),
                            backgroundColor: Colors.grey.shade400,
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
                        Text(
                           'الأذان القادم صلاه ${salahName[_prayerTimeCalculator.salahCalc]}',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          '${_prayerTimeCalculator.formatDuration(timeLeft)}',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                Container(
                  child: TabBar(
                    controller: _controller,
                    tabs: const [
                      Tab(
                        text: 'الصلوات الفائته',
                      ),
                      Tab(
                        text: 'الصلوات اليومية',
                      ),
                    ],
                  ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  customCard("4", "عشاء"),
                                  customCard("3", "مغرب"),
                                  customCard("4", "عصر"),
                                  customCard("4", "ضهر"),
                                  customCard("2", "فجر"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.date_range_outlined),
                                    color: Colors.blue[900], onPressed: () => _selectDate(context),
                                  ),
                                  const Text("حدد يوم",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            prayerData == null
                                ? const Center(child: CircularProgressIndicator())
                                : customSalah("الفجر",Checkbox(
                              //tristate: true,
                              activeColor: Colors.blue[900],
                                value: prayerData == null ? false : prayerData!.prayer1,
                                onChanged: (value){
                                  setState(() {
                                    prayerData!.prayer1 = value!;
                                  });
                                  _savePrayerData();
                            })),
                            customSalah("الضهر",Checkbox(
                              //tristate: true,
                                activeColor: Colors.blue[900],
                                value: prayerData == null ? false : prayerData!.prayer2,
                                onChanged: (value){
                              setState(() {
                                prayerData!.prayer2 = value!;
                              });
                              _savePrayerData();
                            })),
                            customSalah("العصر",Checkbox(
                              //tristate: true,
                                activeColor: Colors.blue[900],
                                value: prayerData == null ? false : prayerData!.prayer3,
                                onChanged: (value){
                              setState(() {
                                prayerData!.prayer3 = value!;
                              });
                              _savePrayerData();
                            })),
                            customSalah("المغرب",Checkbox(
                              //tristate: true,
                                activeColor: Colors.blue[900],
                                value: prayerData == null ? false : prayerData!.prayer4, onChanged: (value){
                              setState(() {
                                prayerData!.prayer4 = value!;
                              });
                              _savePrayerData();
                            })),
                            customSalah("العشاء",Checkbox(
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
                        Column(
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
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              width: Get.width * .95,
                              height: Get.height * .06,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow:const [
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
                                        LinearProgressBar.progressTypeLinear,
                                        // Use Linear progress
                                        currentStep: prayerCurrent == null ? 0: prayerCurrent!.calculation,
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
                              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false : prayerCurrent!.prayer1,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer1 = value ?? false;
                                          });
                                          _savePrayerDataCurrent();
                                        }),
                                    Text(
                                      'النافله',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer2,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer2 = value!;
                                            if (value) {
                                              prayerCurrent!.calculation++;
                                              _savePrayerDataCurrent();
                                            } else {
                                              prayerCurrent!.calculation--;
                                              _savePrayerDataCurrent();
                                            }
                                          });
                                          _savePrayerDataCurrent();
                                        }),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer3,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer3 = value!;
                                          });
                                          _savePrayerDataCurrent();
                                        }),
                                  ]),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer4,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer4 = value!;

                                          });
                                          _savePrayerDataCurrent();
                                        }),
                                    Text(
                                      'النافلة',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer5,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer5 = value!;
                                            if (value) {
                                              prayerCurrent!.calculation++;
                                              _savePrayerDataCurrent();
                                            } else {
                                              prayerCurrent!.calculation--;
                                              _savePrayerDataCurrent();
                                            }
                                          });
                                          _savePrayerDataCurrent();
                                        }),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer6,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer6 = value!;
                                            if (value) {
                                              prayerCurrent!.calculation++;
                                              _savePrayerDataCurrent();
                                            } else {
                                              prayerCurrent!.calculation--;
                                              _savePrayerDataCurrent();
                                            }
                                          });
                                          _savePrayerDataCurrent();
                                        }),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer7,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer7 = value!;

                                          });
                                          _savePrayerDataCurrent();
                                        }),
                                    Text(
                                      'النافلة',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer8,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer8 = value!;
                                            if (value) {
                                              prayerCurrent!.calculation++;
                                              _savePrayerDataCurrent();
                                            } else {
                                              prayerCurrent!.calculation--;
                                              _savePrayerDataCurrent();
                                            }
                                          });
                                          _savePrayerDataCurrent();
                                        }),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer9,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer9 = value!;

                                          });
                                          _savePrayerDataCurrent();
                                        }),
                                    Text(
                                      'النافلة',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer10,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer10 = value!;
                                            if (value) {
                                              prayerCurrent!.calculation++;
                                              _savePrayerDataCurrent();
                                            } else {
                                              prayerCurrent!.calculation--;
                                              _savePrayerDataCurrent();
                                            }
                                          });
                                          _savePrayerDataCurrent();
                                        }),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: prayerCurrent == null ? false :prayerCurrent!.prayer11,
                                        onChanged: (value) {
                                          setState(() {
                                            prayerCurrent!.prayer11 = value!;
                                          });
                                          _savePrayerDataCurrent();
                                        }),
                                  ]),
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

                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget customCard(num,text){
    return SizedBox(
      height: 70,
      width: 70,
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
  Widget customSalah(text,Checkbox chkBox){
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(text,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
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
