import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:prayer_app/view/auth/edit_profile.dart';
import 'package:prayer_app/view/auth/reset_password.dart';
import 'package:prayer_app/view/home/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../provider/boolNotifier.dart';
import '../../widgets/circularClipper.dart';
import 'dailyGoals.dart';

class Profile extends StatefulWidget {
  final String username;
  final String email;

  const Profile({super.key, required this.username, required this.email});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Future<void> storeImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', path);
  }

  Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('imagePath');
  }

  File? _image;
  String _imageUrl = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${pickedFile.name}';
      final file = File(pickedFile.path);

      // Copy the image to the app's document directory
      await file.copy(filePath);

      // Store the image path in SharedPreferences
      await storeImagePath(filePath);

      setState(() {
        _image = File(filePath);
      });
    }
  }

  Future<void> _loadImage() async {
    final path = await getImagePath();
    if (path != null) {
      setState(() {
        _image = File(path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage(); // Load image path when the app starts
  }

  @override
  Widget build(BuildContext context) {
    final boolNotifier = Provider.of<BoolNotifier>(context).counter;
    double height = 170; // Reduced height
    double width = 2 * height; // Increased width
    double radius = height / 3;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/back ground.jpeg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade400,
                              child: Image.asset(
                                'icons/img_1.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // CircleAvatar(
                          //   child: Icon(Icons.notifications_none),
                          //   backgroundColor: Colors.grey.shade400,
                          //   radius: 20,
                          // ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const Settings());
                            },
                            child: CircleAvatar(
                              radius: 20,
                              child: Image.asset(
                                'icons/img.png',
                                width: 20,
                                height: 20,
                              ),
                              backgroundColor: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.4,
                  width: Get.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: Center(
                            child: _image != null
                                ? CircleAvatar(
                                    radius: radius,
                                    backgroundImage: Image.file(_image!)
                                        .image, // Replace with your avatar image path
                                  )
                                : CircleAvatar(
                                    radius: radius,
                                    backgroundImage: AssetImage(
                                        'images/worker.png'), // Replace with your avatar image path
                                  ),
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.2,
                          child: ClipPath(
                            clipper: CircularClipper(radius),
                            child: Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage('images/back ground2.jpeg'),
                                  // Replace with your asset path
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.3,
                          left: Get.width * 0.3,
                          child: Column(
                            children: [
                              Text(
                                widget.username,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.email,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: Get.height * 0.3,
                            right: Get.width * 0.7,
                            child: IconButton(
                                onPressed: () {
                                  Get.to( Editprofile(username: widget.username, email: widget.email,));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ))),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: Get.width * .95,
                  height: Get.height * .4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, blurRadius: 2, spreadRadius: .5)
                      ]),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            textDirection: TextDirection.rtl,
                            'مهام اليوم',
                            style: TextStyle(
                                letterSpacing: .6,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: (boolNotifier / 10) * 2.5,
                        center: Text(
                          (((boolNotifier * 2.5) * 100)/10).toString() + "%",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        footer: TextButton(
                          onPressed: () {
                            Get.off(const DailyGoals());
                          },
                          child: Text(
                            textDirection: TextDirection.rtl,
                            'عرض باقي اهداف اليوم',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: buttonColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue[900],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.to(ResetPasswordView());
                          }, icon: Icon(Icons.arrow_back_ios)),
                      Text(
                        textDirection: TextDirection.rtl,
                        'تغيير كلمة السر ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  width: Get.width * .95,
                  height: Get.height * .06,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, blurRadius: 1, spreadRadius: .5)
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
