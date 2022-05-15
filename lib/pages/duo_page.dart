import 'package:flutter/material.dart';
import 'package:pomoduo/providers/room_provider.dart';
import 'package:provider/provider.dart';
import 'package:pomoduo/models/room.dart';
import 'package:pomoduo/providers/timer_provider.dart';
import 'package:pomoduo/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DuoPage extends StatefulWidget {
  const DuoPage({Key? key}) : super(key: key);

  @override
  State<DuoPage> createState() => _DuoPageState();
}

class _DuoPageState extends State<DuoPage> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _createRoom() async {
    final roomId = await _createRoomDialog();
    DateTime date = new DateTime.now().toLocal();

    Room room = Room(
        roomName: roomId.toString(),
        numberOfUsers: 0,
        users: [],
        starstAt: date,
        status: false,
        focusDuration: context.read<TimerProvider>().focusDuration ~/ 60,
        shortBreakDuration: context.read<TimerProvider>().shortBreakDuration ~/ 60,
        longBreakDuration: context.read<TimerProvider>().longBreakDuration ~/ 60);

    bool res = await room.createRoom();
    if (res) {
      context.read<TimerProvider>().updateFromFetch(
          room.focusDuration * 60, room.longBreakDuration * 60, room.shortBreakDuration * 60);
      context.read<RoomProvider>().changeRoomName(room.roomName);
    }
    print(res);
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Room Not found'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _joinRoom() async {
    final roomId = await _openRoomDialog();
    var room = await joinRoom(roomId.toString());
    // room.then((value) => print(value.toMap()));
    if (room.roomName.toString() != '-1') {
      context.read<TimerProvider>().updateFromFetch(
          room.focusDuration * 60, room.longBreakDuration * 60, room.shortBreakDuration * 60);
      context.read<RoomProvider>().changeRoomName(room.roomName);
    } else {
      context.read<RoomProvider>().changeRoomName("-");
      _showToast(context);
    }

    print(room.toMap());

// Check if room id is valid

// if valid, change to timer
  }

  void _enterRoomId() {
    print(controller.text.toUpperCase());
    Navigator.of(context).pop(controller.text);
  }

  Future<String?> _openRoomDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: PomoduoColor.foregroundColor,
          title: const Text("Join a room"),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter room code",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: PomoduoColor.themeColor),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
              ),
              onPressed: _enterRoomId,
              child: const Text(
                "Join",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Future<String?> _createRoomDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: PomoduoColor.foregroundColor,
          title: const Text("Create a room"),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter room code",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: PomoduoColor.themeColor),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
              ),
              onPressed: _enterRoomId,
              child: const Text(
                "Create",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Center(child: Text("Duo Mode")),
        const SizedBox(
          height: 36,
        ),
        const Center(
          child: RoomName(),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: _createRoom,
          child: const Text(
            "Create Room",
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: _joinRoom,
          child: const Text(
            "Join Room",
          ),
        )
      ],
    );
  }
}

class RoomName extends StatelessWidget {
  const RoomName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context, roomProvider, widget) {
      return Text(
        "Room joined: ${roomProvider.roomName}",
        style: const TextStyle(color: Colors.white70),
      );
    });
  }
}
