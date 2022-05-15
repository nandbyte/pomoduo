import 'package:flutter/material.dart';
import 'package:pomoduo/utils/constants.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Text(
          "Statistics",
          style: PomoduoStyle.pageTitleStyle,
        )
      ],
    );
  }
}
