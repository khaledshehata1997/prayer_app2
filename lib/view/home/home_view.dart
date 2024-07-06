import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
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
  final _pageNo = [  Azkar(), const Quran(),const StartUp(),const Fasting(),Prayer()];

  @override
  Widget build(BuildContext context) {
    GlobalKey<ConvexAppBarState> appBarKey = GlobalKey<ConvexAppBarState>();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedPage,
        onTap: (int i) {
           setState(() {
            selectedPage = i;
            appBarKey.currentState?.animateTo(i);
          });
        },
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FlutterIslamicIcons.tasbih2,color: Colors.blue[900],),
            label: 'الأذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIslamicIcons.quran2,color: Colors.blue[900],),
            label: 'القران',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,color: Colors.blue[900],),
            label: 'رئيسيه',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIslamicIcons.iftar,color: Colors.blue[900],),
            label: 'الصيام',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIslamicIcons.prayingPerson,color: Colors.blue[900],),
            label: 'الصلاه',
          ),
        ],
      ),
        body: _pageNo[selectedPage]
    );
      // bottomNavigationBar:ConvexAppBar(
      //   key: appBarKey,
      //   backgroundColor: Colors.grey,
      //   items:const [
      //     TabItem(icon: Icon(Icons.person,color: Colors.white,), title: 'الأذكار'),
      //     TabItem(icon: Icon(Icons.contact_page_outlined,color: Colors.white,), title: 'القران'),
      //     TabItem(icon: Icon(Icons.calendar_month,color: Colors.white,), title: 'رئيسيه'),
      //     TabItem(icon: Icon(Icons.add,color: Colors.white,), title: 'الصيام'),
      //     TabItem(icon: Icon(Icons.home_outlined,color: Colors.white,),title: 'الصلاه'),
      //   ],
      //   style: TabStyle.fixedCircle,
      //   initialActiveIndex: selectedPage,
      //   elevation: 5,
      //   onTap: (int i) {
      //     setState(() {
      //       selectedPage = i;
      //       appBarKey.currentState?.animateTo(i);
      //     });
      //   },
      // ),
  }
}
