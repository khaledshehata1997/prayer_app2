import 'package:flutter/material.dart';
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
    Search(),
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
          indicatorColor: Colors.blue,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.folder_copy_outlined),
              selectedIcon: Icon(Icons.folder_copy),
              label: 'القران صوتي',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.my_library_books_sharp),
              icon: Icon(Icons.my_library_books_sharp),
              label: 'المصحف',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.my_library_books_sharp),
              icon: Icon(Icons.my_library_books_sharp),
              label: 'البحث',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.my_library_books_sharp),
              icon: Icon(Icons.my_library_books_sharp),
              label: 'الفهرس',
            ),
          ],
        ),
        body: screens[currentPageIndex]);
  }
}
