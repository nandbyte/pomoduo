import 'package:flutter/material.dart';
import 'package:pomoduo/utils/constants.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text("Settings"),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 36, 0, 16.0),
          child: Text("Focus Time"),
        ),
        CustomRadioButton(
          elevation: 0,
          absoluteZeroSpacing: false,
          selectedColor: PomoduoColor.themeColor,
          unSelectedColor: PomoduoColor.foregroundColor,
          buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.white60,
          ),
          enableShape: true,
          enableButtonWrap: true,
          buttonLables: const ["20 m", "25 m", "30 m", "35 m", "40 m", "45 m"],
          buttonValues: const ["20", "25", "30", "35", "40", "45"],
          radioButtonValue: (value) {
            print(value);
          },
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 36, 0, 16.0),
          child: Text("Short Break Time"),
        ),
        CustomRadioButton(
          elevation: 0,
          absoluteZeroSpacing: false,
          selectedColor: PomoduoColor.themeColor,
          unSelectedColor: PomoduoColor.foregroundColor,
          buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.white60,
          ),
          enableShape: true,
          enableButtonWrap: true,
          buttonLables: const ["5 m", "10 m", "15 m"],
          buttonValues: const ["5", "10", "15"],
          radioButtonValue: (value) {
            print(value);
          },
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 36, 0, 16.0),
          child: Text("Long Break Time"),
        ),
        CustomRadioButton(
          elevation: 0,
          absoluteZeroSpacing: false,
          selectedColor: PomoduoColor.themeColor,
          unSelectedColor: PomoduoColor.foregroundColor,
          buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.white60,
          ),
          enableShape: true,
          enableButtonWrap: true,
          buttonLables: const ["15 m", "20 m", "25 m"],
          buttonValues: const ["15", "20", "25"],
          radioButtonValue: (value) {
            print(value);
          },
        ),
      ],
    );
  }
}
