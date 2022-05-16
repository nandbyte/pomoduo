import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pomoduo/models/room.dart';

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
  bool _isDuoMode = false;
  String _roomAdmin = "";
  String _roomDocId = "";

  String get roomName => _roomName;
  int get numberOfUsers => _numberOfUsers;
  List<String> get users => _users;
  DateTime get startingTime => _startingTime;
  int get focusDuration => _focusDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  bool get isTimerRunning => _isTimerRunning;
  String get roomError => _roomError;
  bool get isDuoMode => _isDuoMode;
  String get roomAdmin => _roomAdmin;

  changeRoomAdmin(String admin) {
    _roomAdmin = admin;
    notifyListeners();
  }

  changeDuoMode(bool mode) {
    _isDuoMode = !_isDuoMode;
    notifyListeners();
  }

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
  // Future<bool> createRoom() async {
  //   CollectionReference db = FirebaseFirestore.instance.collection("rooms");
  //   var roomsWithSameName =
  //       await db.where("roomName", isEqualTo: roomName).get();
  //   if (roomsWithSameName.size > 0) {
  //     return false;
  //   } else {
  //     await db.add(toMap());
  //   }
  //   notifyListeners();
  //   return true;
  // }

  Future<void> leaveRoom(String roomName, String userID) async {
    var rooms = await FirebaseFirestore.instance
        .collection("rooms")
        .where("roomName", isEqualTo: roomName)
        .get();
    for (var room in rooms.docs) {
      var id = room.id;
      List<String> currentUsers = List.castFrom(room.data()["users"]);
      if (currentUsers.contains(userID)) {
        await FirebaseFirestore.instance.collection("rooms").doc(id).update({
          "users": FieldValue.arrayRemove([userID.toString()]),
          "numberOfUsers": FieldValue.increment(-1),
        });
        break;
      }
    }
    _roomName = "-";
    _numberOfUsers = 0;
    _isDuoMode = false;
    notifyListeners();
  }

  Future<Room> joinRoom(String _roomName, String userID) async {
    Room room = Room(
        roomName: '-1',
        adminID: '',
        numberOfUsers: 0,
        users: [],
        starstAt: DateTime.now(),
        status: false,
        focusDuration: 0,
        shortBreakDuration: 0,
        longBreakDuration: 0);
    var docId;
    var snapshot = await FirebaseFirestore.instance
        .collection("rooms")
        .where("roomName", isEqualTo: _roomName)
        .get()
        .then((value) {
      if (value.size > 0) {
        for (var snap in value.docs) {
          var data = snap;
          _roomDocId = snap.id;
          print(data.toString());
          if (_roomName == data.data()["roomName"].toString()) {
            print("here");
            room = Room(
                roomName: data.data()["roomName"].toString(),
                adminID: data.data()['adminID'].toString(),
                numberOfUsers: data.data()["numberOfUsers"] ?? 0,
                users: data.data()["users"].cast<String>() ?? [],
                starstAt: data.data()["starstAt"].toDate(),
                status: data.data()["status"] ?? false,
                focusDuration: data.data()["focusDuration"] ?? 0,
                shortBreakDuration: data.data()["shortBreakDuration"] ?? 0,
                longBreakDuration: data.data()["longBreakDuration"] ?? 0);
            break;
          }
        }
      }
    });
    if (!room.users.contains(userID)) {
      await FirebaseFirestore.instance.collection("rooms").doc(docId).update({
        "users": FieldValue.arrayUnion([userID.toString()]),
        "numberOfUsers": FieldValue.increment(1),
      });
    }
    notifyListeners();
    return room;
  }

  void showError(String error) {
    _roomError = error;
    notifyListeners();
  }

  Future<bool> updateRoomStatus(bool status) async {
    CollectionReference db = FirebaseFirestore.instance.collection("rooms");
    var roomObj = await db.where("roomName", isEqualTo: _roomName).get();
    if (roomObj.size > 0) {
      for (var room in roomObj.docs) {
        var id = room.id;
        await db.doc(id).update({"status": status}).then((_) {
          print("Updated to $status");
          return status;
        });
      }
    }
    return false;
  }

  Future<bool> getRoomStatus() async {
    Room room = Room(
        roomName: '-1',
        adminID: '',
        numberOfUsers: 0,
        users: [],
        starstAt: DateTime.now(),
        status: false,
        focusDuration: 0,
        shortBreakDuration: 0,
        longBreakDuration: 0);

    var snapshot = await FirebaseFirestore.instance
        .collection("rooms")
        .where("roomName", isEqualTo: _roomName)
        .get()
        .then((value) {
      if (value.size > 0) {
        var docId;
        int count = 0;
        for (var snap in value.docs) {
          var data = snap;
          print(data.toString());
          if (_roomName == data.data()["roomName"].toString()) {
            print("here");
            room = Room(
                roomName: data.data()["roomName"].toString(),
                adminID: data.data()['adminID'].toString(),
                numberOfUsers: data.data()["numberOfUsers"] ?? 0,
                users: data.data()["users"].cast<String>() ?? [],
                starstAt: data.data()["starstAt"].toDate(),
                status: data.data()["status"] ?? false,
                focusDuration: data.data()["focusDuration"] ?? 0,
                shortBreakDuration: data.data()["shortBreakDuration"] ?? 0,
                longBreakDuration: data.data()["longBreakDuration"] ?? 0);
            break;
          }
        }
      }
    });
    return room.status;
  }

  void init() async {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(_roomDocId)
        .snapshots()
        .listen((event) {
      print(event.data());
      notifyListeners();
    });
  }
}
