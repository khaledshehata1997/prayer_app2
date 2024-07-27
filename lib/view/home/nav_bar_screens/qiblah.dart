import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';
import 'package:prayer_app/qiblah/qiblah_compass.dart';
import 'package:prayer_app/qiblah/qiblah_maps.dart';
import '../../../qiblah/loading_indicator.dart';
import '../profile.dart';
import '../settings.dart';

class Qiblah extends StatefulWidget {
  @override
  _QiblahState createState() => _QiblahState();
}

class _QiblahState extends State<Qiblah> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            alignment: Alignment.topCenter,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'القبله',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'فَوَلِّ وَجْهَكَ شَطْرَ الْمَسْجِدِ الْحَرَامِ ۚ\n وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ',
                                style: TextStyle(
                                    fontSize: 19,
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
                  Expanded(
                    child: FutureBuilder(
                      future: _deviceSupport,
                      builder: (_, AsyncSnapshot<bool?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return LoadingIndicator();
                        if (snapshot.hasError)
                          return Center(
                            child: Text("Error: ${snapshot.error.toString()}"),
                          );

                        if (snapshot.data!)
                          return QiblahCompass();
                        else
                          return QiblahMaps();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
