import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';

class Editprofile extends StatefulWidget {
  final String username;
  final String email;
  const Editprofile({super.key, required this.username, required this.email});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  var myEmail,myName;
  File? _imageFile;
  String _imageUrl = '';
  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedImage =
    await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }
  Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('imagePath');
  }
  Future<void> _loadImage() async {
    final path = await getImagePath();
    nameController.text = widget.username;
    emailController.text = widget.email;
    if (path != null) {
      setState(() {
        _imageFile = File(path);
      });
    }
  }
  final _fromKey = GlobalKey<FormState>();
  Future<void> storeUserData(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
  }


  @override
  void initState() {
    super.initState();
    _loadImage();
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Form(
      key: _fromKey,
      child: Scaffold(
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Get.height * .07,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'تعديل الملف الشخصي'.tr,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _imageFile != null
                        ? CircleAvatar(
                      radius: 80,
                      child:  InkWell(
                        onTap: () async {
                          await _pickImage();
                        },
                        child:  Icon(
                          Icons.add_a_photo,
                          size: 40,
                        ),
                      ),
                      backgroundImage: Image.file(_imageFile!)
                          .image,
                    ) : CircleAvatar(
                      radius: 80,
                      child:  InkWell(
                        onTap: () async {
                          await _pickImage();
                        },
                        child:  Icon(
                          Icons.add_a_photo,
                          size: 40,
                        ),
                      ),
                      backgroundImage: AssetImage("images/worker.png"),
                    )
                    ,
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(blurRadius: 2, color: Colors.grey)
                          ]),
                      width: Get.width * .9,
                      height: Get.height * .92,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: Get.height * .02,
                          ),
                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   child: const Text(
                          //     'Name',
                          //     style: TextStyle(
                          //         fontSize: 17,
                          //         fontWeight: FontWeight.w300,
                          //         color: Colors.grey),
                          //   ),
                          // ),
                          CustomText(
                            text: 'الاسم',
                            size: 18,
                            isBold: false,
                            alignment: Alignment.topRight,
                          ),
                          CustomTextFormField(
                            onSaved: (val){
                              myName = val;
                            },
                            controller: nameController,
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
                              myEmail = val;
                            },
                            txt1: "البريد الألكتروني لا يمكن ان يكون اكبر من 100 حرف",
                            txt2: "البريد الألكتروني لا يمكن ان يكون اقل من 4 احرف",
                            controller: emailController,
                            onChanged: () {},
                            hint: 's@gmail.com',
                            scure: false,
                          ),
                          SizedBox(
                            height: Get.height * .03,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (_fromKey.currentState!.validate()) {

                                  setState(() {
                                    storeUserData(nameController.text, emailController.text);
                                  });
                                  Get.back();
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[900],
                                  fixedSize:
                                  Size.fromWidth(Get.width * .8)),
                              child: const Text(
                                'تعديل',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
