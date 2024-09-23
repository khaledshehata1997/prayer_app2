import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prayer_app/provider/boolNotifier.dart';
import 'package:prayer_app/view/home/profile.dart';
import 'package:prayer_app/view/home/settings.dart';
import 'package:provider/provider.dart';

import '../../widgets/circularClipper.dart';
import 'nav_bar_screens/prayer_model/prayerModelCurrent.dart';
import 'nav_bar_screens/prayer_model/sqlite/database_helper.dart';

class DailyGoals extends StatefulWidget {
  const DailyGoals({super.key});

  @override
  State<DailyGoals> createState() => _DailyGoalsState();
}

class _DailyGoalsState extends State<DailyGoals> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  PrayerCurrent? prayerCurrent;

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void _getPrayerDataCurrent() async {
    prayerCurrent = await dbHelper.getPrayerCurrent(_formatDate(selectedDate));
    if (prayerCurrent == null) {
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

  @override
  void initState() {
    super.initState();
    _getPrayerDataCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final boolNotifier = Provider.of<BoolNotifier>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
              child: Consumer<BoolNotifier>(
                builder: (context, boolNotifier, child) {
                  return Column(
                    children: [
                      // SizedBox(
                      //   height: Get.height * 0.05,
                      // ),
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
                                // CircleAvatar(
                                //   child: Icon(Icons.notifications_none),
                                //   backgroundColor: Colors.grey.shade400,
                                //   radius: 20,
                                // ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const Settings(),
                                      withNavBar: true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
                        height: Get.height * 0.01,
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
                                    'جميع اهداف اليوم',
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
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  currentStep: prayerCurrent == null
                                      ? 0
                                      : prayerCurrent!.calculation,
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
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      customSalah(
                          "صلاه النوافل",
                          Checkbox(
                              activeColor: Colors.blue[900],
                              value: boolNotifier.value2,
                              onChanged: (val) {
                                boolNotifier.setValue2(val!);
                              })),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      customSalah(
                          "الورد القراني اليومي",
                          Checkbox(
                              activeColor: Colors.blue[900],
                              value: boolNotifier.value3,
                              onChanged: (val) {
                                boolNotifier.setValue3(val!);
                              })),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      customSalah(
                          "تعويض صلاه فائته",
                          Checkbox(
                              activeColor: Colors.blue[900],
                              value: boolNotifier.value4,
                              onChanged: (val) {
                                boolNotifier.setValue4(val!);
                              })),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      customSalah(
                          "صيام يوم الأثنين",
                          Checkbox(
                              activeColor: Colors.blue[900],
                              value: boolNotifier.value5,
                              onChanged: (val) {
                                boolNotifier.setValue5(val!);
                              })),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customSalah(text, Checkbox chkBox) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          chkBox,
          Text(
            text,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
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
