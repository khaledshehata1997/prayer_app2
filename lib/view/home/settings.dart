import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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
                        'اعدادات التطبيق'
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
              height: Get.height * 0.03,
            ),
            SizedBox(
              height: Get.height * 0.07,
              width: double.infinity,
              child: Card(
                child: ListTile(
                  title: Center(child: Text("التنبيهات",textDirection: TextDirection.rtl,)),
                  leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
                  trailing: IconButton(onPressed: (){}, icon: Icon(Icons.menu_book_outlined)),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            SizedBox(
              height: Get.height * 0.22,
              width: double.infinity,
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Switch(
                        activeColor: CupertinoColors.white,
                          activeTrackColor: CupertinoColors.activeBlue,
                          value: true,
                          onChanged: (_){}),
                      trailing: Text("ايقاف الصلاه والصيام",textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child: Align(
                        alignment: Alignment.centerRight,
                          child: Text("يستخدم ايام العذر الشرعي",textDirection: TextDirection.rtl,)),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                          child: Text("التذكير بالصلاه مره اخري بعد",textDirection: TextDirection.rtl
                            ,style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),)),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      items: null, onChanged: (_){},hint:
                    Align(
                      alignment: Alignment.centerRight,
                        child: Text("5 ايام",textDirection: TextDirection.rtl,)),),
                  ],
                ) ),
              ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            SizedBox(
              height: Get.height * 0.07,
              width: double.infinity,
              child: Card(
                child: ListTile(
                  title: Center(child: Text("تغيير كلمه السر",textDirection: TextDirection.rtl,)),
                  leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
                  trailing: IconButton(onPressed: (){}, icon: Icon(Icons.menu_book_outlined)),
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
                child: ListTile(
                  title: Center(child: Text("الشروط والأحكام",textDirection: TextDirection.rtl,)),
                  leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
                  trailing: IconButton(onPressed: (){}, icon: Icon(Icons.menu_book_outlined)),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
