import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/view/auth/sign_in_view.dart';

import '../home/home_view.dart';
class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeView())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/prayer.png'),
              SizedBox(
                height: Get.height * .05,
              ),

              const Text(
                'جميع الحقوق محفوظه',
                style: TextStyle(color: Colors.black,fontSize: 20 ),
              ),
            ],
          )),
    );
  }
}
