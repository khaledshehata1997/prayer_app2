import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prayer_app/constants.dart';
import 'package:prayer_app/provider/prayer_provider.dart';
import 'package:prayer_app/view/azkar/azkar_view.dart';
import 'package:prayer_app/view/home/nav_bar_screens/fasting.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_view.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran.dart';
import 'package:prayer_app/view/home/nav_bar_screens/startup_view.dart';
import 'package:prayer_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sibha/sibha_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Widget> _pageNo = [  const StartUp(), const Quran(),const Azkar(),const Prayer()];
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        activeColorPrimary: buttonColor,
        inactiveColorPrimary: Colors.grey,
        icon: Icon(Icons.home_outlined,),
        contentPadding: 2,
        title: 'رئيسيه',
      ),

      PersistentBottomNavBarItem(
        activeColorPrimary: buttonColor,
        inactiveColorPrimary: Colors.grey,
        icon: Icon(FlutterIslamicIcons.quran2),
        contentPadding: 2,
        title: 'القران',
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: buttonColor,
        inactiveColorPrimary: Colors.grey,
        icon: const Icon(FlutterIslamicIcons.tasbih2,),
        contentPadding: 2,
        title: 'الأذكار',

      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: buttonColor,
        inactiveColorPrimary: Colors.grey,
        icon: const Icon(FlutterIslamicIcons.prayingPerson,),
        contentPadding: 2,
        title: 'الصلاه',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _pageNo,
        items: _navBarsItems(),
        confineToSafeArea: true,

        onItemSelected: (value) {

        },
        padding: EdgeInsets.all(5),
// margin: EdgeInsets.all(5),
        backgroundColor: Colors.white,

        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        navBarStyle: NavBarStyle.style1,
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
