import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Notify extends StatefulWidget {
  const Notify({super.key});

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Center(
                      child: Text(
                        'التنبيهات'
                        ,textDirection: TextDirection.rtl
                        ,style: TextStyle(
                          fontSize: 30,fontWeight: FontWeight.w800,color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: Get.height * 0.07,
              width: double.infinity,
              child: Card(
                child:ListTile(
                  leading: Switch(
                      activeColor: CupertinoColors.white,
                      activeTrackColor: CupertinoColors.activeBlue,
                      value: false,
                      onChanged: (_){}),
                  trailing: Text("صوت الأذان",textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            SizedBox(
              height: Get.height * 0.07,
              width: double.infinity,
              child: Card(
                child:ListTile(
                  leading: Switch(
                      activeColor: CupertinoColors.white,
                      activeTrackColor: CupertinoColors.activeBlue,
                      value: false,
                      onChanged: (_){}),
                  trailing: Text("تنبيه قبل الأذان بنصف ساعه",textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            SizedBox(
              height: Get.height * 0.12,
              width: double.infinity,
              child: Card(
                child:ListTile(
                  leading: Switch(
                      activeColor: CupertinoColors.white,
                      activeTrackColor: CupertinoColors.activeBlue,
                      value: true,
                      onChanged: (_){}),
                  title: Text("تنبيه الصلاه الفائته",textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                  subtitle: Text("قبل الصلاه التي تليها بنصف ساعه",textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 17,color: Colors.grey),),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            SizedBox(
              height: Get.height * 0.07,
              width: double.infinity,
              child: Card(
                child:ListTile(
                  leading: Switch(
                      activeColor: CupertinoColors.white,
                      activeTrackColor: CupertinoColors.activeBlue,
                      value: true,
                      onChanged: (_){}),
                  trailing: Text("الأشعارات",textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
