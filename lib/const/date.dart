import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CurrentTimeModel extends ChangeNotifier {
  String _currentTime = '';
  String _currentDay = '';
  String _currentMonth = '';
  String _currentDate = '';

  String get currentTime => _currentTime;
  String get currentDay => _currentDay;
  String get currentMonth => _currentMonth;
  String get currentDate => _currentDate;

  void updateCurrentDate() {
    final currentDate =
        DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(DateTime.now());
    _currentDate = currentDate;
    notifyListeners();
  }

  void updateCurrentTime() {
    final currentTime = DateFormat('HH:mm').format(DateTime.now());
    _currentTime = currentTime;
    notifyListeners();
  }

  void updateCurrentDay() {
    initializeDateFormatting(
        'fr_FR', null);

    final currentDay = DateFormat('dd', 'fr_FR').format(DateTime.now());
    _currentDay = currentDay;
    notifyListeners();
  }

  void updateCurrentMonth() {
    initializeDateFormatting(
        'fr_FR', null);

    final currentMonth = DateFormat('MM', 'fr_FR').format(DateTime.now());
    _currentMonth = currentMonth;
    notifyListeners();
  }

  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateCurrentTime();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  dateFormat(
    list,
  ) {
      var dateString = list["date"];
      DateTime givenDateTime = DateTime.parse(dateString);
      DateTime currentDateTime = DateTime.now();
      Duration elapsedTime = currentDateTime.difference(givenDateTime);
      String formattedTime =
          '${elapsedTime.inHours}:${elapsedTime.inMinutes.remainder(60)}:${elapsedTime.inSeconds.remainder(60)}';
      return formattedTime;
  }
}