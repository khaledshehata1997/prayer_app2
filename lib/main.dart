import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/auth/sign_up_view.dart';
import 'view/auth/splash_view.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView()
    );
  }
}
