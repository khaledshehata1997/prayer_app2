import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/test.dart';
import 'package:prayer_app/view/auth/phone_signIn_view.dart';
import 'package:prayer_app/view/auth/reset_password.dart';
import 'package:prayer_app/view/auth/sign_up_view.dart';
import 'package:prayer_app/view/home/home_view.dart';
import 'package:prayer_app/widgets/custom_text.dart';
import 'package:prayer_app/widgets/custom_text_form_field.dart';

import '../../constants.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});


  @override
  State<SignInView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignInView> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late String myPassword , myEmail;
  bool isScure = true;
  bool  _isLoading = false;
  signIn() async{
    var formData = formState.currentState;
    if(formData!.validate()){
      formData.save();
      try {
        _isLoading = true;
        setState(() {

        });
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: myEmail,
            password: myPassword
        );
        if(userCredential.user!.emailVerified){
        }else{
          dialog(dialog: DialogType.success, text: "تحقق من بريدك الألكتروني لتفعيل الحساب").show();
        }
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print("error");
          dialog(dialog: DialogType.error, text: "لا يوجد حساب مسجل لهذا البريد الألكتروني").show();
        } else if (e.code == 'wrong-password') {
          print("error");
          dialog(dialog: DialogType.error, text: "كلمة سر خاطئه!").show();
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            margin: EdgeInsets.only(bottom: 50),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 40),
                        width: Get.width * .35,
                        height: Get.height * .18,
                        alignment: Alignment.center,
                        child: Image.asset('icons/Vector.png')),
                    SizedBox(height: Get.height*.04),
                    CustomText(
                      text: 'مرحبا بعودتك',
                      size: 24,
                      isBold: true,
                      alignment: Alignment.center,
                    ),

                    SizedBox(height: Get.height*.06),
                    CustomText(
                      text: 'البريد الالكتروني',
                      size: 18,
                      isBold: false,
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(height: Get.height*.01),
                    CustomTextFormField(
                      controller: email,
                      onSaved: (val){
                        myEmail = val!;
                      },
                      onChanged: () {},
                      hint: '',
                      scure: false,
                      txt1: "البريد الألكتروني لا يمكن ان يكون اكبر من 100 حرف",
                      txt2: "البريد الألكتروني لا يمكن ان يكون اقل من 4 احرف",
                    ),
                    SizedBox(height: Get.height*.025),

                    CustomText(
                      text: ' كلمة السر',
                      size: 18,
                      isBold: false,
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(height: Get.height*.01),
                    CustomTextFormField(
                      isPassword: true,
                      txt1:"كلمة السر لا يمكن ان تكون اكبر من 100 رقم",
                      txt2: "كلمة السر لا يمكن ان تكون اصغر من 4 ارقام",
                      controller: pass,
                      onSaved: (val){
                        myPassword = val!;
                      },
                      onChanged: () {},
                      hint: '',
                      scure: true,
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(ResetPasswordView());
                      },
                      child: CustomText(
                        text: ' هل نسيت كلمة السر؟',
                        size: 18,
                        isBold: false,
                        alignment: Alignment.topRight,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () async{
                          var user =  await signIn();
                          if(user != null && FirebaseAuth.instance.currentUser!.emailVerified){
                           Get.offAll(const HomeView());
                          }else{
                            _isLoading = false;
                            setState(() {
                            });
                          }
                        },
                        child: Container(
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
                          margin: EdgeInsets.only( top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                        ),
                      ),
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
                            color: buttonColor,
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
                    // SizedBox(height: Get.height*.02),
                    // Divider(
                    //   height: 5,
                    // ),
                    // SizedBox(height: Get.height*.02),
                    // CustomText(
                    //   text: 'او',
                    //   size: 17,
                    //   isBold: false,
                    //   alignment: Alignment.center,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.to(const PhoneSignIn());
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     child: Text(
                    //       ' تسجيل الدخول برقم الهاتف',
                    //       style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: buttonColor),
                    //     ),
                    //     decoration: BoxDecoration(
                    //         color:Colors.white,
                    //         borderRadius: BorderRadius.circular(10)),
                    //     margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 60,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  AwesomeDialog dialog ({
    required var dialog,
    required String text,
  }) => AwesomeDialog(
    borderSide: const BorderSide(
        width: 3,
        color: Colors.blue
    ),
    context: context,
    title: "Error",
    dialogType: dialog,
    body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(text,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
    ),
  );
}
