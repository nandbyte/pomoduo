import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pomoduo/pages/duo_page.dart';
import 'package:pomoduo/pages/settings_page.dart';
import 'package:pomoduo/pages/timer_page.dart';
import 'package:pomoduo/pages/statistics_page.dart';
import 'package:pomoduo/providers/google_signin_provider.dart';
import 'package:pomoduo/providers/room_provider.dart';
import 'package:pomoduo/providers/timer_provider.dart';
import 'package:pomoduo/utils/constants.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  AwesomeNotifications().initialize("resource://drawable/", [
    NotificationChannel(
      channelKey: "pomoduo_notification",
      channelName: "Pomoduo",
      channelDescription: "Timer Information",
      defaultColor: PomoduoColor.foregroundColor,
      importance: NotificationImportance.High,
      channelShowBadge: true,
    )
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: PomoduoColor.backgroundColor,
    statusBarColor: PomoduoColor.backgroundColor,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
      ],
      child: const Pomoduo(),
    ),
  );
}

class Pomoduo extends StatelessWidget {
  const Pomoduo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.transparent,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: PomoduoColor.textColor,
              displayColor: PomoduoColor.textColor,
              fontFamily: "Quicksand",
            ),
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

  final List<Widget> _tabList = <Widget>[
    const TimerPage(),
    const DuoPage(),
    const StatisticsPage(),
    const SettingsPage()
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
          child: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 36.0),
              child: _tabList.elementAt(_selectedIndex)),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.watch_later),
              label: "Timer",
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
