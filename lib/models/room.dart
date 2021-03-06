import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Room {
  final String roomName;
  final String adminID;
  int numberOfUsers;
  List<String> users;
  DateTime starstAt;
  int focusDuration;
  int shortBreakDuration;
  int longBreakDuration;
  bool status;

  Room(
      {required this.roomName,
      required this.adminID,
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
      'adminID': adminID,
      'numberOfUsers': numberOfUsers,
      'users': users,
      'starstAt': starstAt,
      'focusDuration': focusDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'status': status == null ? false : status,
    };
  }

  Future<bool> createRoom(String userrID) async {
    CollectionReference db = FirebaseFirestore.instance.collection("rooms");
    var roomsWithSameName =
        await db.where("roomName", isEqualTo: roomName).get();
    if (roomsWithSameName.size > 0) {
      return false;
    } else {
      numberOfUsers = 1;
      users = [userrID];
      await db.add(toMap());
    }
    return true;
  }
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
        docId = snap.id;
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
  return room;
}

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
}

Future<bool> updateRoomStatus(bool status, String _roomName) async {
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

Future<bool> getRoomStatus(String _roomName) async {
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
