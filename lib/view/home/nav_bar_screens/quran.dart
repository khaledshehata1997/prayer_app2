import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/main_screen.dart';
import 'package:prayer_app/view/roqua_view.dart';

import '../../auth/sign_in_view.dart';
import '../profile.dart';
import '../settings.dart';

class Quran extends StatefulWidget {
  const Quran({super.key});

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              // padding: EdgeInsets.only(top: 5),
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
                // SizedBox(
                //   height: Get.height * .06,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final userData = await getUserData();
                              if(FirebaseAuth.instance.currentUser == null){
                                Get.snackbar("لا يمكن الدخول الي الصفحه الشخصيه", "للدخول الي الصفحه الشخصيه برجاء تسجيل الدخول",
                                    colorText: Colors.white,snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.blue[900]);
                                Get.to(SignInView());
                              }else{
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen:  Profile(username: '${userData['username']}',
                                    email: '${userData['email']}',),
                                  withNavBar: true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              }
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
                            onTap: (){
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
                  height: Get.height * .01,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'images/back ground2.jpeg',
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'رسول الله صلي الله عليه وسلم قال:',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            textDirection: TextDirection.rtl,
                            "اقرؤوا القران فأنه يأتي يوم القيامه شفيعا لأصحابه",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * .03,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      Text(
                        style: TextStyle(fontSize: 18),
                        "قراءه القران الكريم",
                        textDirection: TextDirection.rtl,
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
                            color: Colors.grey, blurRadius: 1, spreadRadius: .5)
                      ]),
                ),
                SizedBox(
                  height: Get.height * .03,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.to(const Roqua());
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      Text(
                        style: TextStyle(fontSize: 18),
                        "الرقية الشرعية",
                        textDirection: TextDirection.rtl,
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
