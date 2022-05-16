import 'package:flutter/material.dart';
import 'package:pomoduo/utils/constants.dart';

void showToast(BuildContext context, String toastText) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: PomoduoColor.foregroundColor,
      content: Text(
        toastText,
        style: const TextStyle(
          color: PomoduoColor.textColor,
          fontFamily: "Quicksand",
        ),
      ),
      action: SnackBarAction(
        label: 'GOT IT',
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: PomoduoColor.themeColor,
      ),
    ),
  );
}
