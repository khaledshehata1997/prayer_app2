import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/data/bloc/surah/surah_state.dart';
import 'package:http/http.dart' as http;
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/models/surah_model.dart';

class SurahCubit1 extends Cubit<SurahState> {
  SurahCubit1() : super(SurahInitial());

  Future<void> fetchSurahs() async {
    emit(SurahLoading());

    try {
      print('Fetch Surah');
      final response =
          await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        print('Data: $data');
        List<SurahModel> surahs =
            data.map((surah) => SurahModel.fromJson(surah)).toList();

        emit(SurahLoaded(surahs));
      } else {
        emit(SurahError('Failed to load surahs. Please try again later.'));
      }
    } catch (e) {
      emit(SurahError('An error occurred: $e'));
    }
  }
}
