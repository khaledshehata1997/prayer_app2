import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prayer_app/constants.dart';
import 'package:prayer_app/view/azkar/azkar_view.dart';
import 'package:prayer_app/view/home/nav_bar_screens/fasting.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_view.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran.dart';
import 'package:prayer_app/view/home/nav_bar_screens/startup_view.dart';
import 'package:prayer_app/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sibha/sibha_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _pageNo = [  const StartUp(), const Quran(),Azkar(),Prayer()];
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined, color: Colors.blue[900],),
        contentPadding: 2,
        title: 'رئيسيه',
      ),

      PersistentBottomNavBarItem(
        icon: Icon(FlutterIslamicIcons.quran2, color: Colors.blue[900],),
        contentPadding: 2,
        title: 'القران',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FlutterIslamicIcons.tasbih2, color: Colors.blue[900],),
        contentPadding: 2,
        title: 'الأذكار',

      ),
      PersistentBottomNavBarItem(
        icon: Icon(FlutterIslamicIcons.prayingPerson, color: Colors.blue[900],),
        contentPadding: 2,
        title: 'الصلاه',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        padding: EdgeInsets.all(8),
        context,
        screens: _pageNo,
        items: _navBarsItems(),
        controller: _controller,
        backgroundColor: Colors.white,
        confineToSafeArea: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        navBarStyle: NavBarStyle.style6,
      ),

    );
    //   Scaffold(
    //   bottomNavigationBar: BottomNavigationBar(
    //     elevation: 5,
    //     type: BottomNavigationBarType.fixed,
    //     currentIndex: selectedPage,
    //     onTap: (int i) {
    //        setState(() {
    //         selectedPage = i;
    //         appBarKey.currentState?.animateTo(i);
    //       });
    //     },
    //     items:  <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(FlutterIslamicIcons.tasbih2,color: Colors.blue[900],),
    //         label: 'الأذكار',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(FlutterIslamicIcons.quran2,color: Colors.blue[900],),
    //         label: 'القران',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home_outlined,color: Colors.blue[900],),
    //         label: 'رئيسيه',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(FlutterIslamicIcons.prayingPerson,color: Colors.blue[900],),
    //         label: 'الصلاه',
    //       ),
    //     ],
    //   ),
    //     body: _pageNo[selectedPage]
    // );

  }
}
