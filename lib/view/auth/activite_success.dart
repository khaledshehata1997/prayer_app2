import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayer_app/view/auth/sign_in_view.dart';
import 'package:prayer_app/view/home/home_view.dart';

import '../../widgets/custom_text.dart';
class ActivateSuccess extends StatefulWidget {
  const ActivateSuccess({super.key});

  @override
  State<ActivateSuccess> createState() => _ActivateSuccessState();
}

class _ActivateSuccessState extends State<ActivateSuccess> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      Get.offAll(HomeView());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 24),
                width: Get.width * .25,
                height: Get.height * .15,
                alignment: Alignment.center,
                child: Image.asset('images/prayer.png')),
            CustomText(
              text: 'مرحبا بك',
              size: 24,
              isBold: true,
              alignment: Alignment.topRight,
            ),
            SizedBox(height: Get.height*.02),
            Container(
                margin: EdgeInsets.only(top: 24),
                width: Get.width * .45,
                height: Get.height * .15,
                alignment: Alignment.center,
                child: Image.asset('images/Rectangle.png')),
            SizedBox(height: Get.height*.04),
            Text("تم تفعيل الحساب بنجاح!",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            SizedBox(height: Get.height*.04),
            // SizedBox(
            //   width: Get.width * .9,
            //   height: Get.height * 0.05,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue[900]
            //     ),
            //       onPressed: (){
            //       Get.offAll(SignInView());
            //       }, child: Text("تسجيل الدخول",
            //     textDirection: TextDirection.rtl,style: TextStyle(color: Colors.white,fontSize: 18),)),
            // )

          ],
        ),
      ),
    );
  }
}
