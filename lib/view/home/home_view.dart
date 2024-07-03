import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/constants.dart';
import 'package:prayer_app/view/azkar/azkar_view.dart';
import 'package:prayer_app/view/home/nav_bar_screens/fasting.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_view.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran.dart';
import 'package:prayer_app/view/home/nav_bar_screens/startup_view.dart';
import 'package:prayer_app/widgets/custom_text.dart';

import '../sibha/sibha_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedPage = 2;
  final _pageNo = [  Azkar(), const Quran(),const StartUp(),const Fasting(),const Prayer()];

  @override
  Widget build(BuildContext context) {
    GlobalKey<ConvexAppBarState> appBarKey = GlobalKey<ConvexAppBarState>();
    return Scaffold(
      bottomNavigationBar:ConvexAppBar(
        key: appBarKey,
        backgroundColor: Colors.grey,
        items:const [
          TabItem(icon: Icon(Icons.person,color: Colors.white,), title: 'الأذكار'),
          TabItem(icon: Icon(Icons.contact_page_outlined,color: Colors.white,), title: 'القران'),
          TabItem(icon: Icon(Icons.calendar_month,color: Colors.white,), title: 'رئيسيه'),
          TabItem(icon: Icon(Icons.add,color: Colors.white,), title: 'الصيام'),
          TabItem(icon: Icon(Icons.home_outlined,color: Colors.white,),title: 'الصلاه'),
        ],
        style: TabStyle.fixedCircle,
        initialActiveIndex: selectedPage,
        elevation: 5,
        onTap: (int i) {
          setState(() {
            selectedPage = i;
            appBarKey.currentState?.animateTo(i);
          });
        },
      ),
      body: _pageNo[selectedPage]
    );
  }
}
