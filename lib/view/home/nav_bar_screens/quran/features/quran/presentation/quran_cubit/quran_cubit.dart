import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/core/usecases/usecase.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/domain/entities/quran_audio_entity.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/domain/entities/quran_entity.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/quran_usecase.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranStates> {
  final QuranUsecase quranUsecase;
  final QuranAudioUsecase quranAudioUsecase;

  QuranCubit({required this.quranUsecase, required this.quranAudioUsecase})
      : super(InitialQuranState());

  static QuranCubit get(context) => BlocProvider.of(context);

  String surahID = '';
  String url = '';

  getQuranFun() async {
    emit(GetQuranLoading());

    Either<Failure, QuranEntity> response = await quranUsecase(NoParams());
    response.fold((failure) => emit(GetQuranError(error: failure.message)),
        (quranEntity) => emit(GetQuranSuccess(quranEntity: quranEntity)));
  }

  getQuranAudioFun() async {
    emit(GetQuranAudioLoading());

    Either<Failure, QuranAudioEntity> response =
        await quranAudioUsecase(AudioParams(
      surahId: surahID,
    ));
    response.fold((failure) => emit(GetQuranAudioError(error: failure.message)),
        (quranEntity) {
      url = "http://${quranEntity.audioFileEntity.audioUrl}";
      return emit(GetQuranAudioSuccess(quranEntity: quranEntity));
    });
  }
}
