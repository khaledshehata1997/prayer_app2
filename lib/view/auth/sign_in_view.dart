import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/view/auth/sign_up_view.dart';
import 'package:prayer_app/widgets/custom_text.dart';
import 'package:prayer_app/widgets/custom_text_form_field.dart';

import '../../constants.dart';

class SignInView extends StatefulWidget {

  @override
  State<SignInView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignInView> {
  bool isScure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 50),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 24),
                    width: Get.width * .35,
                    height: Get.height * .18,
                    alignment: Alignment.center,
                    child: Image.asset('images/prayer.png')),
                SizedBox(height: Get.height*.04),
                CustomText(
                  text: 'مرحبا بعودتك',
                  size: 24,
                  isBold: true,
                  alignment: Alignment.center,
                ),

                SizedBox(height: Get.height*.04),
                CustomText(
                  text: 'البريد الالكتروني',
                  size: 18,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),
                CustomTextFormField(
                  onChanged: () {},
                  hint: 's@gmail.com',
                  scure: false,
                ),
                SizedBox(height: Get.height*.05),

                CustomText(
                  text: ' كلمة السر',
                  size: 18,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),
                CustomTextFormField(
                  onChanged: () {},
                  hint: '***********',
                  scure: true,
                ),
                CustomText(
                  text: ' هل نسيت كلمة السر؟',
                  size: 18,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),

                Container(
                  alignment: Alignment.center,
                  child: Text(
                    ' تسجيل الدخول',
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
                SizedBox(height: Get.height*.016),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){
                        Get.to(SignUpView());
                      },
                      child: CustomText(
                        lineUnderText: true,
                        text: ' انشاء حساب',
                        size: 18,
                        isBold: true,
                        alignment: Alignment.topRight,
                      ),
                    ),
                    CustomText(
                      text: ' ليس لديك حساب ؟',
                      size: 17,
                      isBold: false,
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
                SizedBox(height: Get.height*.016),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
