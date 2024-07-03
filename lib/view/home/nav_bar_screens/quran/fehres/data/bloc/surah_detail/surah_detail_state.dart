import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/models/surah_detail_model.dart';

abstract class SurahDetailState {}

class SurahDetailInitial extends SurahDetailState {}

class SurahDetailLoading extends SurahDetailState {}

class SurahDetailLoaded extends SurahDetailState {
  final SurahDetailModel surah;

  SurahDetailLoaded(this.surah);
}

class SurahDetailError extends SurahDetailState {
  final String message;

  SurahDetailError(this.message);
}
