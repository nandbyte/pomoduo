import 'package:flutter/material.dart';
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
  }

  void _joinRoom() async {
    final roomId = await _openRoomDialog();

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
              onPressed: _createRoom,
              child: const Text(
                "Join",
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
        const Text("Duo Mode"),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
          ),
          onPressed: _createRoom,
          child: const Text(
            "Create Room",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
          ),
          onPressed: _joinRoom,
          child: const Text(
            "Join Room",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
