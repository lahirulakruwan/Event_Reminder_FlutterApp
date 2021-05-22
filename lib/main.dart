import 'package:event_reminder/screens/add_event_screen.dart';
import 'package:event_reminder/screens/event_list_screen.dart';
import 'package:event_reminder/screens/login_screen.dart';
import 'package:event_reminder/screens/register_screen.dart';
import 'package:event_reminder/screens/update_event_screen.dart';
import 'package:event_reminder/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
