import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomoduo/models/room.dart';
import 'package:pomoduo/providers/timer_provider.dart';
import 'package:pomoduo/utils/constants.dart';

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
        focusDuration: context.watch<TimerProvider>().focusDuration,
        shortBreakDuration: context.watch<TimerProvider>().shortBreakDuration,
        longBreakDuration: context.watch<TimerProvider>().longBreakDuration);

    bool res = await room.createRoom();
    print(res);
  }

  void _joinRoom() async {
    final roomId = await _openRoomDialog();
    var room = await joinRoom(roomId.toString());
    // room.then((value) => print(value.toMap()));
    context.read<TimerProvider>().changeFocusDuration(room.focusDuration * 60);
    context
        .read<TimerProvider>()
        .changeLongBreakDuration(room.longBreakDuration * 60);
    context
        .read<TimerProvider>()
        .changeShortBreakDuration(room.shortBreakDuration * 60);

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
                backgroundColor:
                    MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white60),
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
                backgroundColor:
                    MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white60),
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
          child:
              Text("Room joined: -", style: TextStyle(color: Colors.white70)),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: _createRoom,
          child: const Text(
            "Create Room",
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
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