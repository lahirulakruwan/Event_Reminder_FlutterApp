import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        flexibleSpace: Image.asset(
          'assets/back2.jpg',
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 18, top: 20),
                  width: 200.0,
                  child: Image.asset('assets/logo.gif')),
              Text(
                'Event Reminder',
                style: TextStyle(fontSize: 30.0),
              ),
              Text(
                'version: 0.0.1',
                style: TextStyle(fontSize: 20.0, color: Colors.black54),
              ),
              Container(
                margin: EdgeInsets.all(25.0),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    'As a reminder user i need to be able to get reminded of events on a set time',
                    style: TextStyle(fontSize: 15.0, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  '2021-REG-WE-21',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  'IT18115444\nRatnasooriya K.A.L.L.',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  'IT18126020\nRanjith K.H.V.S',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  'IT18121834\nJayasekara A.S',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  'IT18121766\nKariyapperuma.K.A.D.R.L.',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.star),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
