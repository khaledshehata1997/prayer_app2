import 'package:flutter/material.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModelCurrent.dart';

import '../view/home/nav_bar_screens/prayer_model/sqlite/database_helper.dart';


class PrayerProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  PrayerCurrent? prayerCurrentData;

  PrayerProvider() {
    _getPrayerCurrentData();
  }

  Future<void> _getPrayerCurrentData() async {
    DateTime selectedDate = DateTime.now();
    prayerCurrentData = await dbHelper.getPrayerCurrent(_formatDate(selectedDate));
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
      await dbHelper.insertPrayerCurrent(prayerCurrentData!);
    }
  }
}
