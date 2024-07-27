import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/main_screen.dart';
import 'package:prayer_app/view/roqua_view.dart';

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
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5),
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
              SizedBox(
                height: Get.height * .06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: ()async{
                            final userData = await getUserData();
                            Get.off(Profile(username: '${userData['username']}'
                              , email: '${userData['email']}',));
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
                        'رسول الله صلي الله عليه وسلم قال:',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          textDirection: TextDirection.rtl,
                          "اقرؤوا القران فأنه يأتي يوم القيامه شفيعا لأصحابه",
                          style: TextStyle(
                              fontSize: 17,
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
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.menu_book_outlined))
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
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.menu_book_outlined))
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
    );
  }
}
