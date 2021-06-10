import 'package:event_reminder/screens/event_list_screen.dart';
import 'package:event_reminder/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as flutter_notification;

flutter_notification.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
new flutter_notification.FlutterLocalNotificationsPlugin();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
  flutter_notification.AndroidInitializationSettings('bell');
  var initializationSettingsIOS = flutter_notification.IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = flutter_notification.InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      });



  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Event Reminder",
      home: EventListScreen(),
    );
  }
}

