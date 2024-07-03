import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import '../../../constants.dart';

class Prayer extends StatefulWidget {
  const Prayer({super.key});

  @override
  State<Prayer> createState() => _PrayerState();
}

var now = DateTime.now();
var formatter = DateFormat.yMMMEd();
String formatted = formatter.format(now);
int currentFrood = 0;
bool fajrMainValue = false;
bool fajrSecValue = false;
bool dohaValue = false;
bool dohrMainValue = false;
bool dohrSecValue = false;
bool asrValue = false;
bool maghrbMainValue = false;
bool maghrbSecValue = false;
bool ishaMainValue = false;
bool ishaSecValue = false;
bool qeamValue = false;

class _PrayerState extends State<Prayer> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController controller = TabController(length: 2, vsync: this);
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
                          'الأذان القادم صلاه العشاء',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          '01:15:05',
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
                    controller: controller,
                    tabs: [
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
                      controller: controller,
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
                                    color: Colors.blue[900], onPressed: () { },
                                  ),
                                  const Text("حدد يوم",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            customSalah("الفجر"),
                            customSalah("الضهر"),
                            customSalah("العصر"),
                            customSalah("المغرب"),
                            customSalah("العشاء"),
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
                                    formatted,
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
                                        currentStep: currentFrood,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(children: [
                                    Checkbox(
                                        activeColor: buttonColor,
                                        checkColor: Colors.white,
                                        value: fajrMainValue,
                                        onChanged: (value) {
                                          setState(() {
                                            fajrMainValue = value!;

                                          });
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
                                        value: fajrSecValue,
                                        onChanged: (value) {
                                          setState(() {
                                            fajrSecValue = value!;
                                            if (value) {
                                              currentFrood++;
                                            } else {
                                              currentFrood--;
                                            }
                                          });
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
                                        value: dohaValue,
                                        onChanged: (value) {
                                          setState(() {
                                            dohaValue = value!;
                                          });
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
                                        value: dohrMainValue,
                                        onChanged: (value) {
                                          setState(() {
                                            dohrMainValue = value!;

                                          });
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
                                        value: dohrSecValue,
                                        onChanged: (value) {
                                          setState(() {
                                            dohrSecValue = value!;
                                            if (value) {
                                              currentFrood++;
                                            } else {
                                              currentFrood--;
                                            }
                                          });
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
                                        value: asrValue,
                                        onChanged: (value) {
                                          setState(() {
                                            asrValue = value!;
                                            if (value) {
                                              currentFrood++;
                                            } else {
                                              currentFrood--;
                                            }
                                          });
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
                                        value: maghrbMainValue,
                                        onChanged: (value) {
                                          setState(() {
                                            maghrbMainValue = value!;

                                          });
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
                                        value: maghrbSecValue,
                                        onChanged: (value) {
                                          setState(() {
                                            maghrbSecValue = value!;
                                            if (value) {
                                              currentFrood++;
                                            } else {
                                              currentFrood--;
                                            }
                                          });
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
                                        value: ishaMainValue,
                                        onChanged: (value) {
                                          setState(() {
                                            ishaMainValue = value!;

                                          });
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
                                        value: ishaSecValue,
                                        onChanged: (value) {
                                          setState(() {
                                            ishaSecValue = value!;
                                            if (value) {
                                              currentFrood++;
                                            } else {
                                              currentFrood--;
                                            }
                                          });
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
                                        value: qeamValue,
                                        onChanged: (value) {
                                          setState(() {
                                            qeamValue = value!;
                                          });
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
  Widget customSalah(text){
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween,
        children: [
          Checkbox(
              activeColor: buttonColor,
              checkColor: Colors.white,
              value: false,
              onChanged: (_) {
              }),
          Text(
            formatted,
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
