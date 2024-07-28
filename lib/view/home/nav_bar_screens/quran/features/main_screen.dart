import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/presentation/screens/quran_screen.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/presentation/screens/quran_surah_screen.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/screens/surah_list.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/search.dart';

import '../core/utils/media_query_values.dart';

import 'quran_audio/presentation/screens/recitations_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [
    const QuranSurahScreen(),
    const QuranScreen(),
    const SurahListScreen()
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.blue[900],
          selectedIndex: currentPageIndex,
          destinations:  <Widget>[
            NavigationDestination(
              icon: Icon(FlutterIslamicIcons.takbir,color: Colors.blue[900],),
              selectedIcon: Icon(FlutterIslamicIcons.takbir,color: Colors.white,),
              label: 'القران صوتي',
            ),
            NavigationDestination(
              selectedIcon: Icon(FlutterIslamicIcons.solidQuran,color: Colors.white,),
              icon: Icon(FlutterIslamicIcons.solidQuran,color: Colors.blue[900],),
              label: 'المصحف',
            ),
            // NavigationDestination(
            //   selectedIcon: Icon(Icons.my_library_books_sharp),
            //   icon: Icon(Icons.my_library_books_sharp),
            //   label: 'البحث',
            // ),
            NavigationDestination(
              selectedIcon: Icon(Icons.book,color: Colors.white,),
              icon: Icon(Icons.book,color: Colors.blue[900],),
              label: 'الفهرس',
            ),
          ],
        ),
        body: screens[currentPageIndex]);
  }
}
