import 'package:flutter/material.dart';
import 'package:pomoduo/main.dart';
import 'package:pomoduo/utils/constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _tabList = <Widget>[
    Text(
      'Solo Mode',
    ),
    Text(
      'Duo Mode',
    ),
    Text(
      'Statistics',
    ),
    Text(
      'Settings',
    ),
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
      body: Center(
        child: _tabList.elementAt(_selectedIndex),
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
        onTap: _changeTab,
      ),
    );
  }
}
