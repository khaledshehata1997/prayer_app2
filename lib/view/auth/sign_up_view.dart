import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/view/auth/activate.dart';
import 'package:prayer_app/view/auth/sign_in_view.dart';
import 'package:prayer_app/widgets/custom_text.dart';
import 'package:prayer_app/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  var Name, myemail, password,myphone;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isScure = true;
  signUp() async {
    var formData = formState.currentState;
    if(formData!.validate()){
      formData.save();

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: myemail,
            password: password
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
            borderSide: BorderSide(
                width: 3,
                color: Colors.blue
            ),
            context: context,
            title: "Error",
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("password is too weak",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ),
          )..show();
          print('The password provided is too weak.');
        } else if(e.code == 'invalid-email'){
          AwesomeDialog(
            borderSide: BorderSide(
                width: 3,
                color: Colors.blue
            ),
            context: context,
            title: "Error",
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("This is not email address type",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),
          )..show();
        }
        else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
            borderSide: BorderSide(
                width: 3,
                color: Colors.blue
            ),
            context: context,
            title: "Error",
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("The account already exists for that email",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),
          )..show();
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }else{
      print("Not Valid");
    }
  }
  Future<void> storeUserData(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formState,
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
                    onSaved: (val){
                      Name = val;
                    },
                    controller: name,
                    txt1: "الاسم لا يمكن ان يكون اكبر من 100 حرف",
                    txt2: "الاسم لا يمكن ان يكون اصغر من 4 احرف",
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
                    onSaved: (val){
                      myemail = val;
                    },
                    txt1: "البريد الألكتروني لا يمكن ان يكون اكبر من 100 حرف",
                    txt2: "البريد الألكتروني لا يمكن ان يكون اقل من 4 احرف",
                    controller: email,
                    onChanged: () {},
                    hint: 's@gmail.com',
                    scure: false,
                  ),
                  SizedBox(height: Get.height*.016),

                  CustomText(
                    text: 'ر قم الهاتف',
                    size: 18,
                    isBold: false,
                    alignment: Alignment.topRight,
                  ),
                  CustomTextFormField(
                    controller: phone,
                    onSaved: (val){
                      myphone = val;
                    },
                    txt1: "رقم الهاتف غير صحيح",
                    txt2: "رقم الهاتف غير صحيح",
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
                    controller: pass,
                    onSaved: (val){
                      password = val;
                    },
                    txt1: "كلمة السر لا يمكن ان تكون اكبر من 100 رقم",
                    txt2: "كلمة السر لا يمكن ان تكون اقل من 4 ارقام",
                    onChanged: () {},
                    hint: '***********',
                    scure: true,
                  ),
                  SizedBox(height: Get.height*.016),
                  GestureDetector(
                    onTap: ()async{
                      storeUserData(name.text, email.text);
                        UserCredential response = await signUp();
                        setState(() {
                          FirebaseAuth.instance.currentUser!.sendEmailVerification();
                        });
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
