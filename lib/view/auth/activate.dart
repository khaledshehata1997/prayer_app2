import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/constants.dart';
import 'package:prayer_app/view/auth/activite_success.dart';

import '../../widgets/custom_text.dart';
import 'sign_up_view.dart';

class Activate extends StatefulWidget {
  const Activate({super.key});

  @override
  State<Activate> createState() => _ActivateState();
}

class _ActivateState extends State<Activate> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;
  }

  Future<void> _checkEmailVerified() async {
    await user.reload();
    user = _auth.currentUser!;
    if (user.emailVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ActivateSuccess(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لم يتم تفعيل البريد الألكتروني')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset('images/back ground.jpeg',
              fit: BoxFit.cover,),
            Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 24),
                    width: Get.width * .25,
                    height: Get.height * .15,
                    alignment: Alignment.center,
                    child: Image.asset('icons/Vector.png')),
                CustomText(
                  text: 'مرحبا بك',
                  size: 24,
                  isBold: true,
                  alignment: Alignment.topRight,
                ),
                SizedBox(height: Get.height*.02),
                Container(
                    margin: EdgeInsets.only(top: 24),
                    width: Get.width * .6,
                    // height: Get.height * .2,
                    alignment: Alignment.center,
                    child: Image.asset('images/Rectangle.png',fit: BoxFit.fill,)),
                SizedBox(height: Get.height*.04),
                CustomText(
                  text: 'ستصلك رساله علي البريد الالكتروني ',
                  size: 20,
                  isBold: false,
                  alignment: Alignment.center,
                ),
                CustomText(
                  text: ' لتفعيل الحساب',
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
                        color: buttonColor,
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
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    onPressed: _checkEmailVerified,
                    child: Text('التحقق من التفعيل ',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
