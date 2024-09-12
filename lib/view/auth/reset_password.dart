// reset password service
import 'package:firebase_auth/firebase_auth.dart';
// reset password view

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_text_form_field.dart';


class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue[900],
      //   centerTitle: true,
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   title: const Text('إعادة تعيين كلمة السر',style:TextStyle(color: Colors.white),),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              SizedBox(height: 200,),
              CustomTextFormField(
                txt1: "البريد الألكتروني لا يمكن ان يكون اكبر من 100 حرف",
                txt2: "البريد الألكتروني لا يمكن ان يكون اقل من 4 احرف",
                controller: _emailController,
                onChanged: () {},
                hint: 's@gmail.com',
                scure: false,
              ),
               SizedBox(
                height: Get.height * .04,
              ),
              SizedBox(
                width: double.infinity,
                height: Get.height * .06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                    )
                  ),
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
                    fontSize: 20,
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


