import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/widgets/custom_text_form_field.dart';

import 'constants.dart';
class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
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
                        'تغيير كلمه السر'
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
              height: Get.height * 0.16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("ادخل البريد الالكتروني المسجل بحسابك لتصلك رسالة بها الرمز المطلوب لاعاده تعيين كلمه السر",
              textDirection: TextDirection.rtl,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                  child: Text("البريد الألكتروني",textDirection: TextDirection.rtl,)),
            ),
            CustomTextFormField(
              onChanged: (){},
              hint: "Mohamedibra031@gmail.com",
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            GestureDetector(
              onTap: (){
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'ارسال',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color:buttonColor,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                width: MediaQuery.of(context).size.width,
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
