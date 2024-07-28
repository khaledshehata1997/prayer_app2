import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/constants/style/colors.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/constants/style/text_styles.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/data/bloc/surah_detail/surah_detail_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/data/bloc/surah_detail/surah_detail_state.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/models/surah_model.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/widgets/banner_verse_widget.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/widgets/verses_widget.dart';

class DetailSurahScreen extends StatefulWidget {
  final SurahModel surah;

  const DetailSurahScreen({super.key, required this.surah});

  @override
  State<DetailSurahScreen> createState() => _DetailSurahScreenState();
}

class _DetailSurahScreenState extends State<DetailSurahScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<SurahDetailCubit>()
        .fetchSurahsDetails(surahNumber: widget.surah.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/back ground.jpeg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(1),
                color: Colors.white,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'images/back ground2.jpeg',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                                      widget.surah.name,
                                      style: kHeading6.copyWith(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 24.0),
                    child: BlocBuilder<SurahDetailCubit, SurahDetailState>(
                      builder: (context, state) {
                        if (state is SurahDetailLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SurahDetailError) {
                          return Center(child: Text(state.message));
                        } else if (state is SurahDetailLoaded) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.surah.ayahs.length,
                              itemBuilder: (context, index) {
                                final ayah = state.surah.ayahs[index];
                                return VersesWidget(
                                    ayahs: ayah,
                                    surah: state.surah.number.toString());
                              },
                            ),
                          );
                        } else {
                          return const Center(child: Text('Error BLoC'));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
