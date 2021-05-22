import 'package:flutter/material.dart';

class UpdateEventScreen extends StatefulWidget {
  const UpdateEventScreen({Key key}) : super(key: key);

  @override
  _UpdateEventScreenState createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event Screen'),
      ),
      body: Center(
        child: Text('Update Event Screen'),
      ),
    );
  }
}
