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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        Center(child: Text("Settings")),
        FocusTimeSettings(),
        ShortBreakTimeSettings(),
        LongBreakTimeSettings(),
        AccountSettings()
      ],
    );
  }
}

class FocusTimeSettings extends StatefulWidget {
  const FocusTimeSettings({Key? key}) : super(key: key);

  @override
  State<FocusTimeSettings> createState() => _FocusTimeSettingsState();
}

class _FocusTimeSettingsState extends State<FocusTimeSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
          unSelectedColor: Colors.white,
        ),
        enableShape: true,
        enableButtonWrap: true,
        buttonLables: const ["20 m", "25 m", "30 m", "35 m", "40 m", "45 m"],
        buttonValues: const ["20", "25", "30", "35", "40", "45"],
        radioButtonValue: (value) {
          print(value);
        },
      ),
    ]);
  }
}

class ShortBreakTimeSettings extends StatefulWidget {
  const ShortBreakTimeSettings({Key? key}) : super(key: key);

  @override
  State<ShortBreakTimeSettings> createState() => _ShortBreakTimeSettingsState();
}

class _ShortBreakTimeSettingsState extends State<ShortBreakTimeSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
          unSelectedColor: Colors.white,
        ),
        enableShape: true,
        enableButtonWrap: true,
        buttonLables: const ["5 m", "10 m", "15 m"],
        buttonValues: const ["5", "10", "15"],
        radioButtonValue: (value) {
          print(value);
        },
      ),
    ]);
  }
}

class LongBreakTimeSettings extends StatefulWidget {
  const LongBreakTimeSettings({Key? key}) : super(key: key);

  @override
  State<LongBreakTimeSettings> createState() => _LongBreakTimeSettingsState();
}

class _LongBreakTimeSettingsState extends State<LongBreakTimeSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
          unSelectedColor: Colors.white,
        ),
        enableShape: true,
        enableButtonWrap: true,
        buttonLables: const ["15 m", "20 m", "25 m"],
        buttonValues: const ["15", "20", "25"],
        radioButtonValue: (value) {
          print(value);
        },
      ),
    ]);
  }
}

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 36, 0, 16.0),
            child: Text("Account"),
          ),
        ),
        const Center(
          child: Text("Not Logged In", style: TextStyle(color: Colors.white70)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 16.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {},
            child: const Text(
              "Login",
            ),
          ),
        ),
      ],
    );
  }
}
