import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Room {
  final String roomName;
  int numberOfUsers;
  List<String> users;
  DateTime starstAt;
  int focusDuration;
  int shortBreakDuration;
  int longBreakDuration;
  bool status;

  Room(
      {required this.roomName,
      required this.numberOfUsers,
      required this.users,
      required this.starstAt,
      required this.status,
      required this.focusDuration,
      required this.shortBreakDuration,
      required this.longBreakDuration});

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'numberOfUsres': numberOfUsers,
      'users': users,
      'starstAt': starstAt,
      'focusDuration': focusDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'status': status == null ? false : status,
    };
  }

  Future<bool> createRoom() async {
    CollectionReference db = FirebaseFirestore.instance.collection("rooms");
    var roomsWithSameName =
        await db.where("roomName", isEqualTo: roomName).get();
    if (roomsWithSameName.size > 0) {
      return false;
    } else {
      await db.add(toMap());
    }
    return true;
  }
}

Future<Room> joinRoom(String _roomName) async {
  Room room = Room(
      roomName: '-1',
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

  return room;
}
