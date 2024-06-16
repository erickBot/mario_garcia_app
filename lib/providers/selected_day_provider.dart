import 'package:flutter/material.dart';

class SelectedDayProvider extends ChangeNotifier {
  String _selectedDay = '';

  String get currentDay => _selectedDay;

  void setCurrentDay(String day) {
    _selectedDay = day;
    notifyListeners();
  }
}
