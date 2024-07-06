import 'package:intl/intl.dart';

class PrayerTimeCalculator {
  late DateTime _currentTime;

  PrayerTimeCalculator() {
    _currentTime = DateTime.now();
  }

  Duration timeLeftForNextPrayer(DateTime nextPrayerTime) {
    return nextPrayerTime.difference(_currentTime);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void updateCurrentTime() {
    _currentTime = DateTime.now();
  }

  DateTime get currentTime => _currentTime;
}
