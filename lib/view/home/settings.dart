import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/boolNotifier.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
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
                          // CircleAvatar(
                          //   child: Icon(Icons.notifications_none),
                          //   backgroundColor: Colors.grey.shade400,
                          //   radius: 20,
                          // ),
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
                              'أعدادات التطبيق',
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

                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, blurRadius: 1, spreadRadius: .5)
                      ]),
                  height: Get.height * 0.13,
                  width: Get.width,
                  child: Column(
                    children: [
                  ListTile(
                    leading: Consumer<BoolNotifier>(
                      builder: ( context, boolNotifier,child) {
                      return Switch(
                          activeColor: CupertinoColors.white,
                          activeTrackColor: CupertinoColors.activeBlue,
                          value: boolNotifier.value,
                          onChanged: (val) {
                              boolNotifier.setValue(val);
                          });
                      },
                    ),
                    trailing: Text(
                      "ايقاف الصلاه والصيام",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "يستخدم ايام العذر الشرعي",
                          textDirection: TextDirection.rtl,
                        )),
                  ),

                                      ],
                                    ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
                      Text(
                        textDirection: TextDirection.rtl,
                        'تغيير كلمة السر ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(FlutterIslamicIcons.quran),
                    ],
                  ),
                  width: Get.width * .95,
                  height: Get.height * .06,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, blurRadius: 1, spreadRadius: .5)
                      ]),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
                      Text(
                        textDirection: TextDirection.rtl,
                        'الشروط والأحكام',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(FlutterIslamicIcons.quran),
                    ],
                  ),
                  width: Get.width * .95,
                  height: Get.height * .06,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, blurRadius: 1, spreadRadius: .5)
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
