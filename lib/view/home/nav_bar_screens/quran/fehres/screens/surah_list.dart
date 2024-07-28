import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/constants/style/text_styles.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/widgets/banner_last_read.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/widgets/list_surah_widget.dart';

import '../data/bloc/surah/surah_cubit.dart';
import '../data/bloc/surah/surah_state.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SurahCubit1>().fetchSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    color: Colors.blue[900],
                    'images/icon_quran.png',
                    width: 28.0,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'Quran',
                    style: kHeading6.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SurahCubit1, SurahState>(
                builder: (context, state) {
                  if (state is SurahLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SurahLoaded) {
                    // Display your data
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListSurahWidget(surahs: state.surahs),
                    );
                  } else if (state is SurahError) {
                    return Text('Error: ${state.message}');
                  } else {
                    return const Text('Initial State');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
