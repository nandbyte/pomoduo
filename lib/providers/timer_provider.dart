import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  int _focusDuration = 25 * 60;
  int _shortBreakDuration = 5 * 60;
  int _longBreakDuration = 15 * 60;
  bool _isRunning = false;

  int get focusDuration => _focusDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  bool get isRunning => _isRunning;

  void changeFocusDuration(int newDuration) {
    _focusDuration = newDuration;
    notifyListeners();
  }

  void changeShortBreakDuration(int newDuration) {
    _shortBreakDuration = newDuration;
    notifyListeners();
  }

  void chnageLongBreakDuration(int newDuration) {
    _longBreakDuration = newDuration;
    notifyListeners();
  }
}
