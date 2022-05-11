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
