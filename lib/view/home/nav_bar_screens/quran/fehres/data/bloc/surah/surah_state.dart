import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/models/surah_model.dart';

abstract class SurahState {}

class SurahInitial extends SurahState {}

class SurahLoading extends SurahState {}

class SurahLoaded extends SurahState {
  final List<SurahModel> surahs;

  SurahLoaded(this.surahs);
}

class SurahError extends SurahState {
  final String message;

  SurahError(this.message);
}
