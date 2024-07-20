import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24.0,
                      color: kGrey,
                    ),
                  ),
                  const SizedBox(width: 18.0),
                  Text(
                    widget.surah.name,
                    style: kHeading6.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
      ),
    );
  }
}
