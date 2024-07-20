class PrayerModel {
  String day;
  bool prayer1;
  bool prayer2;
  bool prayer3;
  bool prayer4;
  bool prayer5;

  PrayerModel({
    required this.day,
    required this.prayer1,
    required this.prayer2,
    required this.prayer3,
    required this.prayer4,
    required this.prayer5,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'prayer1': prayer1 ? 1 : 0,
      'prayer2': prayer2 ? 1 : 0,
      'prayer3': prayer3 ? 1 : 0,
      'prayer4': prayer4 ? 1 : 0,
      'prayer5': prayer5 ? 1 : 0,
    };
  }

  factory PrayerModel.fromMap(Map<String, dynamic> map) {
    return PrayerModel(
      day: map['day'],
      prayer1: map['prayer1'] == 1,
      prayer2: map['prayer2'] == 1,
      prayer3: map['prayer3'] == 1,
      prayer4: map['prayer4'] == 1,
      prayer5: map['prayer5'] == 1,
    );
  }
}
