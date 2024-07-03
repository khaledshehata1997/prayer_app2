class EndPoints {
// End Points

//********************************* USER FLOW **********************************//

// AUTH


//GET
  static const quranAudioEndpoint = 'http://api.dev-winner.com/api/quran';


  static const getQuran = 'http://api.alquran.cloud/v1/surah';

  static getSurah(String surahId) =>
      'http://api.alquran.cloud/v1/surah/$surahId/ar.alafasy';

  static getAudio(String surahId) =>
      'http://api.quran.com/api/v4/chapter_recitations/7/$surahId';

  static getAudios(String reciterId) =>
      'http://api.quran.com/api/v4/chapter_recitations/$reciterId?language=ar';

  static getJuz(String juzId) =>
      'http://api.alquran.cloud/v1/juz/$juzId/quran-uthmani';
  static const getRecitations =
      'http://api.quran.com/api/v4/resources/recitations?language=ar';

//POST


//DElETE

//PATCH

}
