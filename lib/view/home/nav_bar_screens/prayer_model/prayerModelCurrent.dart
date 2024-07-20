class PrayerCurrent {
  String day;
  bool prayer1;
  bool prayer2;
  bool prayer3;
  bool prayer4;
  bool prayer5;
  bool prayer6;
  bool prayer7;
  bool prayer8;
  bool prayer9;
  bool prayer10;
  bool prayer11;
  int calculation;

  PrayerCurrent({
    required this.day,
    required this.prayer1,
    required this.prayer2,
    required this.prayer3,
    required this.prayer4,
    required this.prayer5,
    required this.prayer6,
    required this.prayer7,
    required this.prayer8,
    required this.prayer9,
    required this.prayer10,
    required this.prayer11,
     this.calculation = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'prayer1': prayer1 ? 1 : 0,
      'prayer2': prayer2 ? 1 : 0,
      'prayer3': prayer3 ? 1 : 0,
      'prayer4': prayer4 ? 1 : 0,
      'prayer5': prayer5 ? 1 : 0,
      'prayer6': prayer6 ? 1 : 0,
      'prayer7': prayer7 ? 1 : 0,
      'prayer8': prayer8 ? 1 : 0,
      'prayer9': prayer9 ? 1 : 0,
      'prayer10': prayer10 ? 1 : 0,
      'prayer11': prayer11 ? 1 : 0,
      'calculation': calculation,
    };
  }

  static PrayerCurrent fromMap(Map<String, dynamic> map) {
    return PrayerCurrent(
      day: map['day'],
      prayer1: map['prayer1'] == 2,
      prayer2: map['prayer2'] == 1,
      prayer3: map['prayer3'] == 1,
      prayer4: map['prayer4'] == 1,
      prayer5: map['prayer5'] == 1,
      prayer6: map['prayer6'] == 1,
      prayer7: map['prayer7'] == 1,
      prayer8: map['prayer8'] == 1,
      prayer9: map['prayer9'] == 1,
      prayer10: map['prayer10'] == 1,
      prayer11: map['prayer11'] == 1,
      calculation: map['calculation'] ?? 0,
    );
  }
}
