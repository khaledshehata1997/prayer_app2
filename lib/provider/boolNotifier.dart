import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoolNotifier extends ChangeNotifier {
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  bool _value4 = false;
  bool _value5 = false;
  int _counter = 0;

  bool get value1 => _value1;
  bool get value2 => _value2;
  bool get value3 => _value3;
  bool get value4 => _value4;
  bool get value5 => _value5;
  int get counter => _counter;

  BoolNotifier() {
    _loadValues();
  }

  Future<void> _loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    _value1 = prefs.getBool('my_bool_key1') ?? false;
    _value2 = prefs.getBool('my_bool_key2') ?? false;
    _value3 = prefs.getBool('my_bool_key3') ?? false;
    _value4 = prefs.getBool('my_bool_key4') ?? false;
    _value5 = prefs.getBool('my_bool_key5') ?? false;
    _counter = prefs.getInt('my_counter_key') ?? 0;
    notifyListeners();
  }

  Future<void> _updateCounter(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    if (newValue) {
      _counter += 1;
    } else {
      _counter -= 1;
    }
    await prefs.setInt('my_counter_key', _counter);
    notifyListeners();
  }

  Future<void> setValue1(bool newValue) async {
    if (_value1 != newValue) {
      _value1 = newValue;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('my_bool_key1', newValue);
      await _updateCounter(newValue);
      notifyListeners();
    }
  }

  Future<void> setValue2(bool newValue) async {
    if (_value2 != newValue) {
      _value2 = newValue;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('my_bool_key2', newValue);
      await _updateCounter(newValue);
      notifyListeners();
    }
  }

  Future<void> setValue3(bool newValue) async {
    if (_value3 != newValue) {
      _value3 = newValue;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('my_bool_key3', newValue);
      await _updateCounter(newValue);
      notifyListeners();
    }
  }

  Future<void> setValue4(bool newValue) async {
    if (_value4 != newValue) {
      _value4 = newValue;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('my_bool_key4', newValue);
      await _updateCounter(newValue);
      notifyListeners();
    }
  }

  Future<void> setValue5(bool newValue) async {
    if (_value5 != newValue) {
      _value5 = newValue;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('my_bool_key5', newValue);
      await _updateCounter(newValue);
      notifyListeners();
    }
  }
}
