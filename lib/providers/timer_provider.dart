import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomoduo/models/room.dart';

class TimerProvider with ChangeNotifier {
  // Timer settings
  Duration _focusDuration = const Duration(seconds: 25 * 60);
  Duration _shortBreakDuration = const Duration(seconds: 5 * 60);
  Duration _longBreakDuration = const Duration(seconds: 15 * 60);

// Timer data
  late Stopwatch _watch;
  late Timer _countdownTimer;
  bool _isTimerRunning = false;
  Duration _currentSessionDuration = Duration.zero;
  Duration _remainingDuration = Duration.zero;

  // Session data
  int _sessionCount = 0;
  String _sessionModeText = "Focus";

  final List<Session> sessions = [
    Session.focus,
    Session.shortBreak,
    Session.focus,
    Session.shortBreak,
    Session.focus,
    Session.shortBreak,
    Session.focus,
    Session.longBreak
  ];

  int get focusDuration => _focusDuration.inSeconds;
  int get shortBreakDuration => _shortBreakDuration.inSeconds;
  int get longBreakDuration => _longBreakDuration.inSeconds;
  bool get isTimerRunning => _isTimerRunning;
  Duration get remainingDuration => _remainingDuration;
  Duration get currentSessionDuration => _currentSessionDuration;
  int get sessionCount => _sessionCount;
  String get sessionModeText => _sessionModeText;

  TimerProvider() {
    _watch = Stopwatch();

    // TODO: load data from SharedPreferences
    _sessionCount = 0;
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

  updateFromFetch(int newFocusDuration, int newLongBreak, int newShortBreak) {
    _focusDuration = Duration(seconds: newFocusDuration);
    _shortBreakDuration = Duration(seconds: newShortBreak);
    _longBreakDuration = Duration(seconds: newLongBreak);

    notifyListeners();
  }

  toggleTimer(String roomName) {
    if (!_isTimerRunning) {
      updateRoomStatus(true, roomName);
      _startTimer();
      _isTimerRunning = true;
    } else {
      updateRoomStatus(false, roomName);
      _stopTimer();
      _isTimerRunning = false;
    }
  }

  toogleUserTimer() {
    if (!_isTimerRunning) {
      _startTimer();
      _isTimerRunning = true;
    } else {
      _stopTimer();
      _isTimerRunning = false;
    }
  }

  startNonAdminTimer() {
    _startTimer();
    _isTimerRunning = true;
  }

  prepareNewTimer() {
    if (sessions[_sessionCount] == Session.focus) {
      _currentSessionDuration = _focusDuration;
      _sessionModeText = "Focus";
    } else if (sessions[_sessionCount] == Session.shortBreak) {
      _currentSessionDuration = _shortBreakDuration;
      _sessionModeText = "Short Break";
    } else {
      _currentSessionDuration = _longBreakDuration;
      _sessionModeText = "Long Break";
    }

    _remainingDuration = _currentSessionDuration;
  }

  _startTimer() {
    _isTimerRunning = true;
    _watch.reset();
    _watch.start();
    notifyListeners();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  _updateTimer(Timer timer) {
    if (_isTimerRunning) {
      _remainingDuration = _currentSessionDuration - _watch.elapsed;
      notifyListeners();
      if (_remainingDuration == Duration.zero) {
        _processSessionData();
        _stopTimer();
      }
    }
  }

  _stopTimer() {
    _countdownTimer.cancel();
    _watch.stop();
    _isTimerRunning = false;

    prepareNewTimer();

    notifyListeners();
  }

  _processSessionData() {
    _sessionCount = (_sessionCount + 1) % 8;

    notifyListeners();
    // TODO: load from storage and save session count and focus count both incremented by 1
  }
}

enum Session { focus, shortBreak, longBreak }
