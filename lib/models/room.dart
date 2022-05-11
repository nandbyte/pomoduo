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
  var snapshot = await FirebaseFirestore.instance
      .collection("rooms")
      .where("roomName", isEqualTo: _roomName)
      .get();
  if (snapshot.size > 0) {
    var docId;
    for (var snap in snapshot.docs) {
      docId = snap.id;
    }
    print(docId);
    var data =
        await FirebaseFirestore.instance.collection("room").doc(docId).get();
    print(data.data());
    if (data.exists) {
      return Room(
          roomName: data.data()?["roomName"],
          numberOfUsers: data.data()?["numberOfUsers"],
          users: data.data()?["users"],
          starstAt: data.data()?["starstAt"],
          status: data.data()?["status"],
          focusDuration: data.data()?["focusDuration"],
          shortBreakDuration: data.data()?["shortBreakDuration"],
          longBreakDuration: data.data()?["longBreakDuration"]);
    } else {
      print("Not fetched");
      return Room(
          roomName: '',
          numberOfUsers: 0,
          users: [],
          starstAt: DateTime.now(),
          status: false,
          focusDuration: 0,
          shortBreakDuration: 0,
          longBreakDuration: 0);
    }
  } else {
    return Room(
        roomName: '',
        numberOfUsers: 0,
        users: [],
        starstAt: DateTime.now(),
        status: false,
        focusDuration: 0,
        shortBreakDuration: 0,
        longBreakDuration: 0);
  }
}
