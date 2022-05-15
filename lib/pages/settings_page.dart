import 'package:flutter/material.dart';
import 'package:pomoduo/providers/google_signin_provider.dart';
import 'package:provider/provider.dart';
import 'package:pomoduo/providers/timer_provider.dart';
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
        Center(
          child: Text(
            "Settings",
            style: PomoduoStyle.pageTitleStyle,
          ),
        ),
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
        buttonValues: const [20, 25, 30, 35, 40, 45],
        defaultSelected: context.watch<TimerProvider>().focusDuration / 60,
        radioButtonValue: (value) {
          context.read<TimerProvider>().changeFocusDuration(int.parse(value.toString()) * 60);
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
  // void updateShortBreak(int val, BuildContext context) {
  //   context.read<TimerProvider>().
  // }

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
        buttonValues: const [5, 10, 15],
        defaultSelected: context.watch<TimerProvider>().shortBreakDuration / 60,
        radioButtonValue: (value) {
          context.read<TimerProvider>().changeShortBreakDuration(int.parse(value.toString()) * 60);
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
        buttonValues: const [15, 20, 25],
        defaultSelected: context.watch<TimerProvider>().longBreakDuration / 60,
        radioButtonValue: (value) {
          context.read<TimerProvider>().changeLongBreakDuration(int.parse(value.toString()) * 60);
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 36, 0, 16.0),
              child: Text("Account"),
            ),
          ),
          Consumer<GoogleSignInProvider>(
            builder: (context, googleSignInProvider, widget) {
              return (() {
                if (!googleSignInProvider.isSignedIn) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text("Not logged in.", style: TextStyle(color: Colors.white70)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 16.0),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          icon: const Icon(Icons.g_mobiledata),
                          onPressed: () => googleSignInProvider.googleLogin(),
                          label: const Text(
                            "Login with Google",
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CircleAvatar(
                        backgroundColor: PomoduoColor.foregroundColor,
                        backgroundImage:
                            NetworkImage("https://avatars.githubusercontent.com/u/38876495?v=4"),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text("Arctronic Sikder", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child:
                            Text("(arctronic@shihab.com)", style: TextStyle(color: Colors.white70)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 16.0),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(PomoduoColor.themeColor),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            googleSignInProvider.googleLogout();
                          },
                          label: const Text(
                            "Logout ",
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }());
            },
          )
        ],
      ),
    );
  }
}
