import 'package:cloud_firestore/cloud_firestore.dart';

class PomoduoUser {
  String UID;
  String userName;
  String docID;
  String currentRoom;
  List<String> allRooms;
  List<String> allDateOfJoin;

  PomoduoUser(
      {required this.UID,
      required this.userName,
      required this.currentRoom,
      required this.docID,
      required this.allDateOfJoin,
      required this.allRooms});

  Map<String, dynamic> toMap() {
    return {
      'UID': UID,
      'userName': userName,
      'docID': docID,
      'currentRoom': currentRoom,
      'allRooms': allRooms,
      'allDateOfjoin': allDateOfJoin
    };
  }

  Future<PomoduoUser> userSignInUpdateRecord() async {
    PomoduoUser user = PomoduoUser(
        UID: UID,
        docID: docID,
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
        user = PomoduoUser(
            UID: UID,
            userName: userName,
            docID: "",
            currentRoom: "",
            allDateOfJoin: [],
            allRooms: []);
        var obj = FirebaseFirestore.instance
            .collection("users")
            .add(user.toMap())
            .then((value) {
          docID = value.id;
          value.update({"docID": value.id});
        });
        return user;
      } else if (value.size > 0) {
        for (var data in value.docs) {
          user = PomoduoUser(
              UID: data.data()["UID"],
              userName: data.data()["userName"],
              docID: data.data()["docID"].toString(),
              currentRoom: data.data()["currentRoom"],
              allDateOfJoin: data.data()["allDateOfJoin"]?.cast<String>() ?? [],
              allRooms: data.data()["allRooms"]?.cast<String>() ?? []);
          return user;
        }
      }
    });

    return user;
  }
}

Future<void> addJoinHistory(String roomName, String date, String id) async {
  print("Requested doc ID $id");
  await FirebaseFirestore.instance.collection("users").doc(id).update({
    "allDateOfJoin": FieldValue.arrayUnion([date]),
    "allRRooms": FieldValue.arrayUnion([roomName]),
  });
}
