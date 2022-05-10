import 'package:flutter/material.dart';
import 'package:pomoduo/utils/constants.dart';

class DuoPage extends StatefulWidget {
  const DuoPage({Key? key}) : super(key: key);

  @override
  State<DuoPage> createState() => _DuoPageState();
}

class _DuoPageState extends State<DuoPage> {
  void _createRoom() {}

  void _joinRoom() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text("Duo Mode"),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
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
            backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
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
