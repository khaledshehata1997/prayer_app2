import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../home/profile.dart';
import '../home/settings.dart';
class Azkary extends StatefulWidget {
  final File? image;
  const Azkary({super.key, this.image});

  @override
  State<Azkary> createState() => _AzkaryState();
}

class _AzkaryState extends State<Azkary> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
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
                              'اذكاري',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                SizedBox(
                  height: Get.height * 0.7,
                  width: Get.width,
                  child: Center(
                    child: widget.image == null ? Text('قم بأختيار صورة للعرض') : Image.file(widget.image!,fit: BoxFit.fill,),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}
