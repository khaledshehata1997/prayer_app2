import 'package:dartz/dartz.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/core/usecases/usecase.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/domain/entities/quran_audio_entity.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/domain/entities/surah_entity.dart';
import '../../../../core/error/failure.dart';
import '../entities/quran_entity.dart';

abstract class QuranRepository {
  Future<Either<Failure, QuranEntity>> quran(NoParams params);
  Future<Either<Failure, SurahEntity>> surah(SurahParams params);
  Future<Either<Failure, QuranAudioEntity>> audio(AudioParams params);
}
