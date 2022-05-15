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
    () => context.read<TimerProvider>().initializeTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text("Timer"),
        Center(
          child: CircularPercentIndicator(
            radius: 110,
            lineWidth: 15,
            percent: context.read<TimerProvider>().timerPercentage,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: PomoduoColor.themeColor,
            arcType: ArcType.FULL,
            arcBackgroundColor: PomoduoColor.foregroundColor,
            center: Text(
              context.read<TimerProvider>().timerContent,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        Column(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: PomoduoColor.themeColor,
                shape: const CircleBorder(),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () => context.read<TimerProvider>().toggleTimer(),
            ),
          ],
        ),
      ],
    );
  }
}
