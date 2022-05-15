import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  // Timer settings
  Duration _focusDuration = const Duration(seconds: 25 * 60);
  Duration _shortBreakDuration = const Duration(seconds: 5 * 60);
  Duration _longBreakDuration = const Duration(seconds: 15 * 60);

// Timer data
  late Stopwatch _watch;
  late Timer _countdownTimer;

  // Timer data
  bool _isTimerRunning = false;
  Duration _remainingDuration = Duration.zero;

  int get focusDuration => _focusDuration.inSeconds;
  int get shortBreakDuration => _shortBreakDuration.inSeconds;
  int get longBreakDuration => _longBreakDuration.inSeconds;
  bool get isTimerRunning => _isTimerRunning;
  Duration get remainingDuration => _remainingDuration;

  TimerProvider() {
    _watch = Stopwatch();
  }

  changeFocusDuration(int newDuration) {
    _focusDuration = Duration(seconds: newDuration);
    notifyListeners();
  }

  changeShortBreakDuration(int newDuration) {
    _shortBreakDuration = Duration(seconds: newDuration);
    notifyListeners();
  }

  changeLongBreakDuration(int newDuration) {
    _longBreakDuration = Duration(seconds: newDuration);
    notifyListeners();
  }

  updateFromFetch(int newDuration, int newLongBreak, int newShortBrreakk) {
    _focusDuration = Duration(seconds: newDuration);
    _longBreakDuration = Duration(seconds: newLongBreak);
    _shortBreakDuration = Duration(seconds: newShortBrreakk);
    notifyListeners();
  }

  toggleTimer() {
    if (!_isTimerRunning) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  _startTimer() {
    _isTimerRunning = true;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    _watch.reset();
    _watch.start();

    notifyListeners();
  }

  _updateTimer(Timer timer) {
    if (_isTimerRunning) {
      _remainingDuration = _focusDuration - _watch.elapsed;
      notifyListeners();
      if (_remainingDuration == Duration.zero) {
        _stopTimer();
      }
    }
  }

  _stopTimer() {
    _countdownTimer.cancel();
    _watch.stop();
    _isTimerRunning = false;
    _remainingDuration = Duration.zero;

    notifyListeners();
  }
}
