import 'package:flutter/material.dart';

class SoloPage extends StatefulWidget {
  const SoloPage({Key? key}) : super(key: key);

  @override
  State<SoloPage> createState() => _SoloPageState();
}

class _SoloPageState extends State<SoloPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[Text("Solo Mode")],
    );
  }
}
