import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool _isAdmin = false;
  String _roomName = "-";
  String _roomDocId = "";
  // Session data
  int _sessionCount = 0;
  String _sessionModeText = "Focus";
  String _userId = "";

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
  String get roomDocId => _roomDocId;
  String get userId => _userId;

  TimerProvider() {
    _watch = Stopwatch();

    // TODO: load data from SharedPreferences
    _sessionCount = 0;
  }

  changeUserId(String id) {
    print("Req for update uid");
    print("Prev uid = $_userId, current uid =  $id");
    _userId = id;
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

  changeRoomDocId(String id) {
    _roomDocId = id;
    notifyListeners();
  }

  toggleTimer(String roomName, bool isAdmin) {
    if (!_isTimerRunning) {
      _roomName = roomName;
      updateRoomStatus(true, roomName);
      _isAdmin = isAdmin;
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
      print(_remainingDuration.inSeconds);
      if (_remainingDuration.inSeconds == 0) {
        _processSessionData();
        _stopTimer();
      }
    }
  }

  _stopTimer() {
    _countdownTimer.cancel();
    _watch.stop();
    _isTimerRunning = false;
    if (_isAdmin) {
      updateRoomStatus(false, _roomName);
    }
    prepareNewTimer();

    notifyListeners();
  }

  _processSessionData() async {
    if (_sessionCount % 2 == 0) {
      // await FirebaseFirestore.instance.collection("stats").add({
      //   "totalFocusDuration":
      //       FieldValue.increment(currentSessionDuration.inMinutes),
      //   "totalSession": FieldValue.increment(1),
      //   "sessionDate": DateFormat.yMMMMd('en_US').format(DateTime.now()),
      //   "userId": _userId,
      // });
      var snaps = await FirebaseFirestore.instance
          .collection("stats")
          .where("userId", isEqualTo: _userId)
          .get();
      if (snaps.size == 0) {
        await FirebaseFirestore.instance.collection("stats").add({
          "totalFocusDuration":
              FieldValue.increment(currentSessionDuration.inMinutes),
          "totalSession": FieldValue.increment(1),
          "userId": _userId,
          "sessions": FieldValue.arrayUnion([
            {
              "date": DateFormat.yMMMMd('en_US').format(DateTime.now()),
              "session": currentSessionDuration.inMinutes,
            }
          ]),
        });
      } else {
        for (var snap in snaps.docs) {
          print("Rerq for update");
          String docId = snap.id;
          print("Requested DocID $docId and uid $_userId");
          await FirebaseFirestore.instance
              .collection("stats")
              .doc(docId)
              .update({
            "sessions": FieldValue.arrayUnion([
              {
                "date": DateFormat.yMMMMd('en_US').format(DateTime.now()),
                "session": currentSessionDuration.inMinutes,
              }
            ]),
            "lastModifyReq": DateTime.now().toString(),
          });
          break;
        }
      }
    }
    _sessionCount = (_sessionCount + 1) % 8;
    notifyListeners();
    // TODO: load from storage and save session count and focus count both incremented by 1
  }

  Future<void> init() async {
    print("Remote req $_roomDocId");
    // if (_roomName != '-') {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(_roomDocId)
        .snapshots()
        .listen((event) {
      print("Updating");
      print(_roomName);
      bool flag = event.data()?["status"];
      print(flag);
      if (!_isAdmin && flag != _isTimerRunning) {
        toogleUserTimer();
        notifyListeners();
      }
    });
  }
}

enum Session { focus, shortBreak, longBreak }
