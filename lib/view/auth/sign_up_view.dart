import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/view/auth/activate.dart';
import 'package:prayer_app/view/auth/sign_in_view.dart';
import 'package:prayer_app/widgets/custom_text.dart';
import 'package:prayer_app/widgets/custom_text_form_field.dart';

import '../../constants.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
                    width: Get.width * .25,
                    height: Get.height * .1,
                    alignment: Alignment.center,
                    child: Image.asset('images/prayer.png')),
                CustomText(
                  text: 'مرحبا بك',
                  size: 24,
                  isBold: true,
                  alignment: Alignment.topRight,
                ),
                CustomText(
                  text: 'من فضلك قم بادخال البيانات التاليه',
                  size: 23,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),
                CustomText(
                  text: 'الاسم',
                  size: 18,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),
                CustomTextFormField(
                  onChanged: () {},
                  hint: 'سما ياسر',
                  scure: false,
                ),
                SizedBox(height: Get.height*.016),
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
                SizedBox(height: Get.height*.016),

                CustomText(
                  text: ' قم الهاتف',
                  size: 18,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),
                CustomTextFormField(
                  onChanged: () {},
                  hint: '01064871625',
                  scure: false,
                ),
                CustomText(
                  text: 'النوع',
                  size: 18,
                  isBold: false,
                  alignment: Alignment.topRight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: Get.width*.45,
                      height: Get.height*.12,
                      child: Container(
                        child: Image.asset('images/worker.png'),
                        width: 55,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: Get.width*.45,
                      height: Get.height*.12,
                      child: Container(
                        child: Image.asset('images/businessman.png'),
                        width: 55,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ],
                ),
                SizedBox(height: Get.height*.016),

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
                SizedBox(height: Get.height*.016),

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

                GestureDetector(
                  onTap: (){
                    Get.to(Activate());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'انشاء حساب',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                  ),
                ),
                SizedBox(height: Get.height*.016),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){
                        Get.to(SignInView());
                      },
                      child: CustomText(
                        lineUnderText: true,
                        text: 'تسجيل الدخول',
                        size: 18,
                        isBold: true,
                        alignment: Alignment.topRight,
                      ),
                    ),
                    CustomText(
                      text: 'لديك حساب بالفعل ؟',
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
