import 'package:flutter/material.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModel.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModelCurrent.dart';

import '../view/home/nav_bar_screens/prayer_model/sqlite/database_helper.dart';


class PrayerProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  PrayerCurrent? prayerCurrentData;

  PrayerProvider() {
    _getPrayerCurrentData();
    getAllLastPrayers();
  }

  Future<void> _getPrayerCurrentData() async {
    DateTime selectedDate = DateTime.now();
    prayerCurrentData = await dbHelper.getPrayerCurrent(_formatDate(selectedDate));
    debugPrint("prayerCurrentData: ${prayerCurrentData?.toMap()}");
    prayerCurrentData ??= PrayerCurrent(
        day: _formatDate(selectedDate),
        prayer1: false,
        prayer2: false,
        prayer3: false,
        prayer4: false,
        prayer5: false,
        prayer6: false,
        prayer7: false,
        prayer8: false,
        prayer9: false,
        prayer10: false,
        prayer11: false,
        calculation: 0,
      );
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void updatePrayerCurrent(PrayerCurrent prayer) {
    prayerCurrentData = prayer;
    _savePrayerCurrentData();
    notifyListeners();
  }

  Future<void> _savePrayerCurrentData() async {
    if (prayerCurrentData != null) {
      // await dbHelper.insertPrayerCurrent(prayerCurrentData!);
      await dbHelper.updatePrayerCurrent(prayerCurrentData!);
    }
  }
  int fajrMissed = 0;
  int dhuhrMissed = 0;
  int asrMissed = 0;
  int maghribMissed = 0;
  int ishaMissed = 0;
  getAllLastPrayers()async{
    fajrMissed = dhuhrMissed = asrMissed = maghribMissed = ishaMissed = 0;
   final List<PrayerModel> lastPrayers = await dbHelper.getAllPrayers();
   debugPrint('lastPrayers :: ${lastPrayers.length}');
   for (var element in lastPrayers) {
     if(!element.prayer1){
       fajrMissed++;
     }
     if(!element.prayer2) {
       dhuhrMissed++;
     }
     if(!element.prayer3) {
       asrMissed++;
     }
     if(!element.prayer4) {
       maghribMissed++;
     }
     if(!element.prayer5){
       ishaMissed++;
     }
   }
}
}
