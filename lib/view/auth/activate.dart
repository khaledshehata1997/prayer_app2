import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_text.dart';
import 'sign_up_view.dart';

class Activate extends StatelessWidget {
  const Activate({super.key});

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
                width: Get.width * .25,
                height: Get.height * .15,
                alignment: Alignment.center,
                child: Image.asset('icons/email.png')),
            SizedBox(height: Get.height*.04),
            CustomText(
              text: 'ستصلك رساله علي البريد  \nالالكتروني لتفعيل الحساب',
              size: 20,
              isBold: false,
              alignment: Alignment.center,
            ),
            SizedBox(height: Get.height*.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                  onTap: (){

                  },
                  child: CustomText(
                    lineUnderText: true,
                    text: 'اعادة الارسال',
                    size: 18,
                    isBold: true,
                    alignment: Alignment.topRight,
                  ),
                ),
                CustomText(
                  text: 'لم تصلك رسالة ؟',
                  size: 17,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
