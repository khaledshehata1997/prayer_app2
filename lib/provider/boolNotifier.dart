import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoolNotifier extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  BoolNotifier() {
    _loadValue();
  }

  void _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    _value = prefs.getBool('my_bool_key') ?? false;
    notifyListeners();
  }

  void setValue(bool newValue) async {
    _value = newValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('my_bool_key', newValue);
    notifyListeners();
  }
}
