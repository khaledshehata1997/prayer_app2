// reset password service
import 'package:firebase_auth/firebase_auth.dart';
// reset password view

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('إعادة تعيين كلمة السر'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              SizedBox(height: 50,),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الالكتروني',
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                  onPressed: () async {
                    await ResetPasswordService()
                        .resetPassword(_emailController.text.trim());
                    Get.back();
                    Get.snackbar('تم', 'تحقق من بريدك الألكتروني',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green);
                  },
                  child: const Text('اعاده تعيين كلمه السر',style: TextStyle(
                      color: Colors.white
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // forgot password

  Future<void> resetPassword(String email) async {
    try {
      Get.snackbar('جاري التحميل', 'من فضلك انتظر',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue[900]);
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.snackbar('فشل', 'حدث خطأ ما',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red);
    }
  }
}


// forget password service


