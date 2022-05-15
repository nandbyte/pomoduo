import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  // Timer settings
  int _focusDuration = 25 * 60;
  int _shortBreakDuration = 5 * 60;
  int _longBreakDuration = 15 * 60;

  // Timer data
  bool _isTimerRunning = false;
  String _timerContent = "";
  int _remainingTime = 0;
  double _timerPercentage = 0;
  late Timer _countdownTimer;

  int get focusDuration => _focusDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  bool get isTimerRunning => _isTimerRunning;
  String get timerContent => _timerContent;
  double get timerPercentage => _timerPercentage;

  changeFocusDuration(int newDuration) {
    _focusDuration = newDuration;
    notifyListeners();
  }

  changeShortBreakDuration(int newDuration) {
    _shortBreakDuration = newDuration;
    notifyListeners();
  }

  changeLongBreakDuration(int newDuration) {
    _longBreakDuration = newDuration;
    notifyListeners();
  }

  String _formatToTimerContent(int seconds) {
    Duration duration = Duration(seconds: seconds);

    String twoDigits(int number) => number.toString().padLeft(2, "0");
    String minutesLeft = twoDigits(duration.inMinutes.remainder(60));
    String secondsLeft = twoDigits(duration.inSeconds.remainder(60));

    String timerContent = "$minutesLeft:$secondsLeft";

    return timerContent;
  }

  double _getTimerPercentage(int durationLeft, int totalDuration) {
    double timerPercentage = (durationLeft / focusDuration);
    return timerPercentage;
  }

  initializeTimer() {
    _timerContent = _formatToTimerContent(_focusDuration);
    _timerPercentage = _getTimerPercentage(_focusDuration, _focusDuration);
    notifyListeners();
  }

  toggleTimer() {
    if (_isTimerRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  _startTimer() {
    _remainingTime = _focusDuration;
    _isTimerRunning = true;
    _timerPercentage = 1;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  _updateTimer(Timer timer) {
    if (_remainingTime <= 0) {
      _stopTimer();
    } else {
      _remainingTime--;
      _timerContent = _formatToTimerContent(_remainingTime);
      _timerPercentage = _getTimerPercentage(_remainingTime, _focusDuration);
    }
    notifyListeners();
  }

  _stopTimer() {
    _countdownTimer.cancel();
    _isTimerRunning = true;
    _remainingTime = 0;
    _timerContent = _formatToTimerContent(_remainingTime);
    _timerPercentage = _getTimerPercentage(_remainingTime, _focusDuration);
    notifyListeners();
  }
}
