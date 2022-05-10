import 'package:flutter/material.dart';
import 'package:pomoduo/main_page.dart';

void main() => runApp(Pomoduo());

class Pomoduo extends StatelessWidget {
  const Pomoduo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Quicksand-Variable',
      ),
      home: MainPage(),
    );
  }
}
