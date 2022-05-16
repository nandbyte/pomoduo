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
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Center(
              child: Text(
                "Statistics",
                style: PomoduoStyle.pageTitleStyle,
              ),
            ),
            SizedBox(height: 36),
            TotalStatistics(),
            SizedBox(height: 36),
            TotalStatistics(),
            SizedBox(height: 36),
            TotalStatistics(),
            SizedBox(height: 36),
            TotalStatistics(),
            SizedBox(height: 36),
            TotalStatistics(),
          ],
        ),
      ),
    );
  }
}

class TotalStatistics extends StatelessWidget {
  const TotalStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: PomoduoColor.foregroundColor,
        border: Border.all(
          color: PomoduoColor.foregroundColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
          child: Row(
        children: [
          Expanded(
            child: Column(
              children: const [
                Text("Total Sessions"),
                Text(
                  "34",
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            indent: 20,
            endIndent: 0,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: const [
                Text("Total Duration"),
                Text(
                  "34",
                  style: TextStyle(fontSize: 36),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}


// Text(
//           "Hello",
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 24,
//           ),
//         ),