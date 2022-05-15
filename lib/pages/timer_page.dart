import 'package:pomoduo/providers/room_provider.dart';
import 'package:pomoduo/providers/timer_provider.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomoduo/utils/constants.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    if (!context.read<TimerProvider>().isTimerRunning) {
      context.read<TimerProvider>().prepareNewTimer();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text("Timer"),
        const Center(
          child: ArcTimer(),
        ),
        Column(
          children: const [
            ToggleTimerButton(),
            SizedBox(
              height: 64,
            )
          ],
        ),
      ],
    );
  }
}

class ArcTimer extends StatelessWidget {
  const ArcTimer({Key? key}) : super(key: key);

  String formatToTimerContent(int seconds) {
    Duration duration = Duration(seconds: seconds);

    String twoDigits(int number) => number.toString().padLeft(2, "0");
    String minutesLeft = twoDigits(duration.inMinutes.remainder(60));
    String secondsLeft = twoDigits(duration.inSeconds.remainder(60));

    String timerContent = "$minutesLeft:$secondsLeft";

    return timerContent;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(builder: (context, timerProvider, widget) {
      return CircularPercentIndicator(
        radius: 110,
        lineWidth: 15,
        percent: timerProvider.remainingDuration.inSeconds /
            timerProvider.currentSessionDuration.inSeconds,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: PomoduoColor.themeColor,
        arcType: ArcType.FULL,
        arcBackgroundColor: PomoduoColor.foregroundColor,
        center: Text(
          formatToTimerContent(timerProvider.remainingDuration.inSeconds),
          style: const TextStyle(fontSize: 32),
        ),
      );
    });
  }
}

class ToggleTimerButton extends StatelessWidget {
  const ToggleTimerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(builder: (context, timerProvider, widget) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromRadius(36),
          primary: PomoduoColor.themeColor,
          shape: const CircleBorder(),
        ),
        child: ((() {
          if (!timerProvider.isTimerRunning) {
            return const Icon(
              Icons.play_arrow,
              color: Colors.white,
            );
          } else {
            return const Icon(Icons.stop, color: Colors.white);
          }
        })()),
        onPressed: () =>
            context.read<TimerProvider>().toggleTimer(context.read<RoomProvider>().roomName),
      );
    });
  }
}
