
import 'package:flutter/material.dart';

import 'add_event_screen.dart';

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
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {}
          ),
        ],
      ),
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
              leading: Icon(Icons.watch_later_rounded),
              title: Text('Event name'),
              subtitle: Text('Event description'),
              trailing: Icon(Icons.more_vert),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.watch_later_rounded),
              title: Text('Event name'),
              subtitle: Text('Event description'),
              trailing: Icon(Icons.more_vert),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.watch_later_rounded),
              title: Text('Event name'),
              subtitle: Text('Event description'),
              trailing: Icon(Icons.more_vert),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.watch_later_rounded),
              title: Text('Event name'),
              subtitle: Text('Event description'),
              trailing: Icon(Icons.more_vert),
              onTap: () {},
            ),
            Divider(),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context){
              return Dialog(child: AddEventPage(),shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(Radius.circular(12))
              ));
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
