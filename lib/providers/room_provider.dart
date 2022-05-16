import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  String _roomName = "-";
  int _numberOfUsers = 1;
  List<String> _users = [];
  DateTime _startingTime = DateTime.now();
  int _focusDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;
  bool _isTimerRunning = false;
  String _roomError = "";

  String get roomName => _roomName;
  int get numberOfUsers => _numberOfUsers;
  List<String> get users => _users;
  DateTime get startingTime => _startingTime;
  int get focusDuration => _focusDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  bool get isTimerRunning => _isTimerRunning;
  String get roomError => _roomError;

  changeRoomName(String _name) {
    _roomName = _name;
    notifyListeners();
  }

  String getRoomName() {
    if (_roomName != Null) {
      return roomName;
    }
    return "-";
  }

  Map<String, dynamic> toMap() {
    return {
      'roomName': _roomName,
      'numberOfUsres': _numberOfUsers,
      'users': _users,
      'startingTime': _startingTime,
      'focusDuration': _focusDuration,
      'shortBreakDuration': _shortBreakDuration,
      'longBreakDuration': _longBreakDuration,
      'isTimerRunning': _isTimerRunning,
    };
  }

// TODO: Update this function to match state function style
  Future<bool> createRoom() async {
    CollectionReference db = FirebaseFirestore.instance.collection("rooms");
    var roomsWithSameName = await db.where("roomName", isEqualTo: roomName).get();
    if (roomsWithSameName.size > 0) {
      return false;
    } else {
      await db.add(toMap());
    }
    notifyListeners();
    return true;
  }

  void joinRoom(String _roomName) async {
    _roomName = '-1';
    _numberOfUsers = 0;
    _users = [];
    _startingTime = DateTime.now();
    _focusDuration = 0;
    _shortBreakDuration = 0;
    _longBreakDuration = 0;
    _isTimerRunning = false;

    await FirebaseFirestore.instance
        .collection("rooms")
        .where("roomName", isEqualTo: _roomName)
        .get()
        .then((value) {
      if (value.size > 0) {
        for (var data in value.docs) {
          if (_roomName == data.data()["roomName"].toString()) {
            _roomName = data.data()["roomName"].toString();
            _numberOfUsers = data.data()["numberOfUsers"] ?? 0;
            _users = data.data()["users"].cast<String>() ?? [];
            _startingTime = data.data()["startingTime"].toDate();
            _isTimerRunning = data.data()["isTimerRunning"] ?? false;
            _focusDuration = data.data()["focusDuration"] ?? 0;
            _shortBreakDuration = data.data()["shortBreakDuration"] ?? 0;
          }
        }
      }
    });
    notifyListeners();
  }

  void showError(String error) {
    _roomError = error;
    notifyListeners();
  }
}
