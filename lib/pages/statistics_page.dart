import 'package:flutter/material.dart';
import 'package:pomoduo/utils/constants.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class SingleStatisticData {
  String date;
  int session;

  SingleStatisticData({required this.date, required this.session});
}

class _StatisticsPageState extends State<StatisticsPage> {
  int totalSession = 2;
  int totalDuration = 1065;

  List<SingleStatisticData> sessions = [
    SingleStatisticData(date: "March 24, 2022", session: 20),
    SingleStatisticData(date: "March 25, 2022", session: 25),
    SingleStatisticData(date: "March 27, 2022", session: 25),
    SingleStatisticData(date: "March 30, 2022", session: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Center(
            child: Text(
              "Statistics",
              style: PomoduoStyle.pageTitleStyle,
            ),
          ),
          TotalStatistics(
            totalSession: totalSession,
            totalDuration: totalDuration,
          ),
          Column(
            children: (() {
              List<Widget> returnList = [];

              for (int i = sessions.length - 1; i >= 0; i--) {
                returnList.add(SingleStatistics(data: sessions[i], serial: i));
              }

              return returnList;
            }()),
          )
        ],
      ),
    );
  }
}

class TotalStatistics extends StatelessWidget {
  final int totalSession;
  final int totalDuration;

  const TotalStatistics({Key? key, required this.totalSession, required this.totalDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 48, 0, 48),
      child: Column(
        children: [
          const Text(
            "All Time",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
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
                    children: [
                      const Text("Total Duration"),
                      Text(
                        "$totalDuration m",
                        style: const TextStyle(fontSize: 36),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class SingleStatistics extends StatelessWidget {
  final SingleStatisticData data;
  final int serial;

  const SingleStatistics({Key? key, required this.data, required this.serial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        children: [
          Text(
            data.date,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
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
                      children: [
                        const Text("Session Serial"),
                        Text(
                          serial.toString(),
                          style: const TextStyle(fontSize: 36),
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
                      children: [
                        const Text("Duration"),
                        Text(
                          "${data.session} m",
                          style: const TextStyle(fontSize: 36),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
