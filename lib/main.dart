import 'package:flutter/material.dart';

import 'package:pomoduo/pages/duo_page.dart';
import 'package:pomoduo/pages/settings_page.dart';
import 'package:pomoduo/pages/solo_page.dart';
import 'package:pomoduo/pages/statistics_page.dart';
import 'package:pomoduo/utils/constants.dart';

void main() {
  runApp(const Pomoduo());
}

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
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _tabList = <Widget>[
    SoloPage(),
    DuoPage(),
    StatisticsPage(),
    SettingsPage()
  ];

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PomoduoColor.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: _tabList.elementAt(_selectedIndex)),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Solo",
              backgroundColor: PomoduoColor.backgroundColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Duo",
              backgroundColor: PomoduoColor.backgroundColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Statistics",
              backgroundColor: PomoduoColor.backgroundColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
              backgroundColor: PomoduoColor.backgroundColor),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: PomoduoColor.themeColor,
        unselectedItemColor: Colors.white60,
        onTap: _changeTab,
      ),
    );
  }
}
