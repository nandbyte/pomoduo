import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Room {
  final String roomName;
  int numberOfUsres;
  List<String> users;
  DateTime starstAt;
  int timeDuration;
  int breakDuration;
  bool status;

  Room(
      {@required this.roomName,
      this.numberOfUsres = 0,
      this.starstAt = DateTime.now().toString()});
}
