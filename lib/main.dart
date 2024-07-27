import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prayer_app/firebase_options.dart';
import 'package:prayer_app/provider/boolNotifier.dart';
import 'package:prayer_app/view/auth/activate.dart';
import 'package:prayer_app/view/auth/activite_success.dart';
import 'package:prayer_app/view/auth/splash_view.dart';
import 'package:prayer_app/view/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/core/local/cache_helper.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/di/di.dart' as di ;
import 'package:prayer_app/view/home/nav_bar_screens/quran/di/di.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/presentation/audio_cubit/audio_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/presentation/quran_cubit/quran_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/presentation/quran_off/quran_off_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran/presentation/surah_cubit/surah_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/quran_audio/presentation/controller/recitations_cubit/recitations_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/data/bloc/surah/surah_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/fehres/data/bloc/surah_detail/surah_detail_cubit.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/observer.dart';
import 'package:firebase_core/firebase_core.dart';
bool isLogin = false;
void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  //  Wakelock.enable();
  await di.init();
  await CacheHelper.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Bloc.observer = MyBlocObserver();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;

  } else {
    isLogin = true;
  }
  runApp(
      ChangeNotifierProvider(
          create: (context) => BoolNotifier(),
          child: Builder(
            builder: (context) {
              return MyApp();
            }
          )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => QuranOffCubit()),
          BlocProvider(create: (context) => sl<QuranCubit>()),
          BlocProvider(create: (context) => sl<SurahCubit>()),
          BlocProvider(create: (context) => sl<RecitationsCubit>()),
          BlocProvider(create: (context) => sl<AudioCubit>()),
          BlocProvider(create: (context) => SurahCubit1()),
          BlocProvider(create: (context) => SurahDetailCubit()),
    ],
      child: ScreenUtilInit(
        child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
         home: isLogin == false ? SplashView() : const HomeView(),
        //   home: ActivateSuccess(),
            ),
      )
    );
  }
}
