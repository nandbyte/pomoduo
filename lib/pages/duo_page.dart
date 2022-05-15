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

  _createRoom() async {
    final roomName = await _createRoomDialog();

    if (roomName == null) {
      return;
    }

    DateTime date = DateTime.now().toLocal();
    Room room = Room(
        roomName: roomName.toString(),
        numberOfUsers: 0,
        users: [],
        starstAt: date,
        status: false,
        focusDuration: context.read<TimerProvider>().focusDuration ~/ 60,
        shortBreakDuration: context.read<TimerProvider>().shortBreakDuration ~/ 60,
        longBreakDuration: context.read<TimerProvider>().longBreakDuration ~/ 60);

    bool result = await room.createRoom();
    if (result) {
      context.read<TimerProvider>().updateFromFetch(
          room.focusDuration * 60, room.longBreakDuration * 60, room.shortBreakDuration * 60);
      context.read<RoomProvider>().changeRoomName(room.roomName);
    } else {
      _showToast(context, "A room already exist with name $roomName");
    }
  }

  void _showToast(BuildContext context, String toastText) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: PomoduoColor.foregroundColor,
        content: Text(
          toastText,
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'GOT IT',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: PomoduoColor.themeColor,
        ),
      ),
    );
  }

  _joinRoom() async {
    final roomName = await _openRoomDialog();

    if (roomName == null) {
      return;
    }

    var room = await joinRoom(roomName.toString());

    if (room.roomName.toString() != '-1') {
      context.read<TimerProvider>().updateFromFetch(
          room.focusDuration * 60, room.longBreakDuration * 60, room.shortBreakDuration * 60);
      context.read<RoomProvider>().changeRoomName(room.roomName);
    } else {
      context.read<RoomProvider>().changeRoomName("-");
      _showToast(context, "No room named: $roomName");
    }
  }

  void _enterRoomId() {
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
