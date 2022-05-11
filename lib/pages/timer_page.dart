import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomoduo/utils/constants.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  // DateTime _startingTime = DateTime.now();
  String _currentTimerValue = "00:00";
  int _remainingTime = 0;
  double _timerPercentage = 0.0;
  bool _isTimerRunning = false;

// TODO: Swap with global state variables
  int focusDuration = 1 * 60;
  int shortBreakDuration = 5 * 60;
  int longBreakDuraiton = 15 * 60;

  void _toggleTimer() {
    // Stop if running
    if (_isTimerRunning) {
      _stopTimer();
    }

    // Start if stopped
    else {
      _startTimer();
    }
  }

  void _startTimer() {
    final currentTime = DateTime.now();

    // TODO: Rebuild this part for multiplayer pomodoro
    // final timeDifference = currentTime.difference(_startingTime);
    final timeDifference = Duration(seconds: 0);

    setState(() {
      _remainingTime = focusDuration - timeDifference.inSeconds;
      _currentTimerValue = "25:00";
      _isTimerRunning = true;
      _timerPercentage = 1;
    });

    print(_remainingTime);

    Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_remainingTime <= 0) {
      timer.cancel();
      _stopTimer();
      return;
    }

    print(_remainingTime);

    Duration durationLeft = Duration(seconds: _remainingTime);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutesLeft = twoDigits(durationLeft.inMinutes.remainder(60));
    String secondsLeft = twoDigits(durationLeft.inSeconds.remainder(60));

    double durationLeftPercentage = (durationLeft.inSeconds / focusDuration);

    setState(() {
      _currentTimerValue = "$minutesLeft:$secondsLeft";
      _remainingTime--;
      _timerPercentage = durationLeftPercentage;
    });
  }

  void _stopTimer() {
    setState(() {
      _remainingTime = 0;
      _currentTimerValue = "00:00";
      _isTimerRunning = false;
      _timerPercentage = 0;
    });
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
            percent: _timerPercentage,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: PomoduoColor.themeColor,
            arcType: ArcType.FULL,
            arcBackgroundColor: PomoduoColor.foregroundColor,
            center: Text(
              _currentTimerValue,
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
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: _toggleTimer,
            ),
          ],
        ),
      ],
    );
  }
}
