import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';
import 'package:prayer_app/qiblah/qiblah_compass.dart';
import 'package:prayer_app/qiblah/qiblah_maps.dart';
import '../../../qiblah/loading_indicator.dart';

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
          appBar: PreferredSize(
            preferredSize: Size(double.infinity,Get.height*.27), // here the desired height
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
                Image.asset('images/Rectangle 1.png',fit: BoxFit.fitWidth,
                  width: Get.width, ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35,horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround  ,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Image.asset('icons/img_1.png',width: 20,height: 20,),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.notifications_none),
                                backgroundColor: Colors.white,
                                radius: 15,
                              ),
                              SizedBox(width: 15,),
                              CircleAvatar(
                                radius: 15,
                                child: Image.asset('icons/img.png',width: 20,height: 20,),
                                backgroundColor: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'قال تعالي:'
                          ,textDirection: TextDirection.rtl
                          ,style: TextStyle(
                            fontSize: 15,fontWeight: FontWeight.w800,color: Colors.white),
                        ),
                      ),

                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          '"فَوَلِّ وَجْهَكَ شَطْرَ الْمَسْجِدِ الْحَرَامِ ۚ وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"'
                          ,textDirection: TextDirection.rtl
                          ,style: TextStyle(
                            fontSize: 25,color: Colors.white),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),

          ),
          body: FutureBuilder(
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
    );
  }
}
