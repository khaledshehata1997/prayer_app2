import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayer_app/constants.dart';

import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({super.key});

  @override
  _PhoneSignInState createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late String _verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve verification code
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Verification failed
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Save the verification ID for future use
        String smsCode = 'xxxxxx'; // Code input by the user
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        // Sign the user in with the credential
        await _auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: Duration(seconds: 60),
    );
  }
  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Sign the user in (or link) with the auto-generated credential
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithPhoneNumber() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text,
    );

    // Sign the user in (or link) with the credential
    await _auth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
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
                CustomTextFormField(
                  controller: _phoneController,
                  onChanged: () {},
                  hint: 'رقم الهاتف',
                  scure: false,
                  txt1: "",
                  txt2: "",
                ),
                SizedBox(height: Get.height*.04),
                // TextField(
                //   controller: _phoneController,
                //   decoration: InputDecoration(labelText: 'Phone Number'),
                //   keyboardType: TextInputType.phone,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor
                  ),
                  onPressed: _verifyPhoneNumber,
                  child: Text('Verify Phone Number',style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: Get.height*.04),
                CustomTextFormField(
                  controller: _otpController,
                  onChanged: () {},
                  hint: 'OTP',
                  scure: false,
                  txt1: "",
                  txt2: "",
                ),
                SizedBox(height: Get.height*.04),
                // TextField(
                //   controller: _otpController,
                //   decoration: InputDecoration(labelText: 'OTP'),
                //   keyboardType: TextInputType.number,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor
                  ),
                  onPressed: _signInWithPhoneNumber,
                  child: Text('Sign In',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
