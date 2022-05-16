import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomoduo/providers/google_signin_provider.dart';
import 'package:pomoduo/providers/room_provider.dart';
import 'package:provider/provider.dart';
import 'package:pomoduo/models/room.dart';
import 'package:pomoduo/providers/timer_provider.dart';
import 'package:pomoduo/utils/constants.dart';

import '../models/user.dart';

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
      _showToast(context, "Room already exists: $roomName");
    }
  }

  void _showToast(BuildContext context, String toastText) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: PomoduoColor.foregroundColor,
        content: Text(
          toastText,
          style: const TextStyle(
            color: PomoduoColor.textColor,
            fontFamily: "Quicksand",
          ),
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
      addJoinHistory(roomName.toString(), DateTime.now().toString(),
          context.read<GoogleSignInProvider>().documentId.toString());
    } else {
      context.read<RoomProvider>().changeRoomName("-");
      _showToast(context, "No room named: $roomName");
    }
  }

  // TODO: complete this function
  _leaveRoom() async {
    return;
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
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _enterRoomId,
              child: const Text("Join"),
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
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, widget) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Center(
              child: Text(
                "Duo Mode",
                style: PomoduoStyle.pageTitleStyle,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            const Center(
              child: RoomDetails(),
            ),
            const SizedBox(
              height: 36,
            ),
            (() {
              if (context.read<RoomProvider>().roomName == "-") {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: _createRoom,
                      child: const Text(
                        "Create Room",
                        style: TextStyle(fontWeight: FontWeight.w700),
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
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: _leaveRoom,
                      child: const Text(
                        "Leave Room",
                      ),
                    ),
                  ],
                );
              }
            }())
          ],
        );
      },
    );
  }
}

class RoomDetails extends StatelessWidget {
  const RoomDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context, roomProvider, widget) {
      return Column(
        children: [
          const Text(
            "Room Name",
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: roomProvider.roomName.toString(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  backgroundColor: PomoduoColor.foregroundColor,
                  content: Text(
                    "Room name copied: ${roomProvider.roomName}",
                    style: const TextStyle(
                      color: PomoduoColor.textColor,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  action: SnackBarAction(
                    label: "GOT IT",
                    onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
                    textColor: PomoduoColor.themeColor,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: PomoduoColor.foregroundColor,
                border: Border.all(
                  color: PomoduoColor.foregroundColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  roomProvider.roomName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            "Room Members",
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: PomoduoColor.foregroundColor,
              border: Border.all(
                color: PomoduoColor.foregroundColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                roomProvider.numberOfUsers.toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
