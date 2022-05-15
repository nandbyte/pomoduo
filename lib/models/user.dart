import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String UID;
  String userName;
  String currentRoom;
  List<String> allRooms;
  List<String> allDateOfJoin;

  User(
      {required this.UID,
      required this.userName,
      required this.currentRoom,
      required this.allDateOfJoin,
      required this.allRooms});

  Map<String, dynamic> toMap() {
    return {
      'UID': UID,
      'userName': userName,
      'currentRoom': currentRoom,
      'allRooms': allRooms,
      'allDateOfjoin': allDateOfJoin
    };
  }

  Future<User> userSignInUpdateRecord() async {
    User user = User(
        UID: UID,
        userName: userName,
        currentRoom: currentRoom,
        allDateOfJoin: allDateOfJoin,
        allRooms: allRooms);

    await FirebaseFirestore.instance
        .collection("users")
        .where("UID", isEqualTo: UID)
        .get()
        .then((value) {
      if (value.size == 0) {
        user = User(
            UID: UID,
            userName: userName,
            currentRoom: "",
            allDateOfJoin: [],
            allRooms: []);
        FirebaseFirestore.instance.collection("users").add(user.toMap());
        return user;
      } else if (value.size > 0) {
        for (var data in value.docs) {
          user = User(
              UID: data.data()["UID"],
              userName: data.data()["userName"],
              currentRoom: data.data()["currentRoom"],
              allDateOfJoin: data.data()["allDateOfJoin"],
              allRooms: data.data()["allRooms"]);
          return user;
        }
      }
    });

    return user;
  }
}
