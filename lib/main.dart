import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
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
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
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
