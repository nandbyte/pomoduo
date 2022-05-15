import 'package:pomoduo/providers/room_provider.dart';
import 'package:pomoduo/providers/timer_provider.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomoduo/utils/constants.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Pomodoro",
            style: PomoduoStyle.pageTitleStyle,
          ),
          const SizedBox(height: 108),
          const Center(
            child: ArcTimer(),
          ),
          const SizedBox(height: 24),
          const Center(
            child: SessionProgressIndicator(),
          ),
          const SizedBox(height: 108),
          Column(
            children: const [
              ToggleTimerButton(),
              SizedBox(
                height: 64,
              )
            ],
          ),
        ],
      ),
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
        progressColor:
            timerProvider.sessionCount % 2 == 0 ? PomoduoColor.focusColor : PomoduoColor.breakColor,
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

class SessionProgressIndicator extends StatelessWidget {
  const SessionProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, widget) {
        return SizedBox(
          width: 128,
          child: StepProgressIndicator(
            totalSteps: 7,
            currentStep: timerProvider.sessionCount,
            size: 14,
            selectedColor: PomoduoColor.themeColor,
            unselectedColor: PomoduoColor.foregroundColor,
            // customColor: (index) => index % 2 == 0 ? PomoduoColor.themeColor : Colors.amber.shade400,
            customStep: (index, color, _) {
              Color containerColor;
              IconData containerIconData;

              if (index < timerProvider.sessionCount) {
                containerIconData = Icons.check;

                if (index % 2 == 0) {
                  containerColor = PomoduoColor.focusColor;
                } else {
                  containerColor = PomoduoColor.breakColor;
                }
              } else {
                containerColor = PomoduoColor.foregroundColor;
                containerIconData = Icons.remove;
              }

              return Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Icon(
                  containerIconData,
                  color: PomoduoColor.backgroundColor,
                  size: 8,
                ),
              );
            },
          ),
        );
      },
    );
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
          primary: timerProvider.sessionCount % 2 == 0
              ? PomoduoColor.focusColor
              : PomoduoColor.breakColor,
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
