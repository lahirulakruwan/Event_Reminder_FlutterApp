import 'package:flutter/material.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List Screen'),
      ),
      body: Center(
        child: Text('Event List Screen'),
      ),
    );
  }
}
