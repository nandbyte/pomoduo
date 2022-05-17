import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createTimerNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(id: 4, channelKey: "pomoduo_notification"),
  );
}
