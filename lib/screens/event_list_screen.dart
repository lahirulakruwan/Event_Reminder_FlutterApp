import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as flutter_notification;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer';
import 'package:event_reminder/model/add_Event_Model.dart';
import 'dart:async';
import 'package:event_reminder/sqflite/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:condition/condition.dart';

import 'add_event_screen.dart';


class EventListScreen extends StatefulWidget {


  const EventListScreen({Key key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {

  flutter_notification.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new flutter_notification.FlutterLocalNotificationsPlugin();
  String timeString;
  final formKey = new GlobalKey<FormState>();
  var dbHelper = DBHelper();
  List<AddEvent> eventList;
  int count = 0;
  String _selectedTime = 'Pick Time';

  @override
  Future<void> initState(){
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }


  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<AddEvent>> eventList = dbHelper.getEvents();
      eventList.then((eventList) {
        setState(() {
          this.eventList = eventList;
          print(this.eventList);
          this.count = eventList.length;
        });
      });
    });
  }

  Future<List<AddEvent>> events;

  refreshList() {
    setState(() {
      events = dbHelper.getEvents();

      // for(int i=0;i<this.count;i++)
      // {
      //
      //
      //     var now = new DateTime.now();
      //     var formatter = new DateFormat('yyyy-MM-dd');
      //     String formattedDate = formatter.format(now);
      //     String eventDate = formatter.format(DateTime.parse(eventList[i].eventDate));
      //     print("hurrrrrrrrreeeeeeee");
      //     print(formattedDate);
      //     print(eventDate);
      //
      //     if(eventDate.compareTo(formattedDate) == true){
      //
      //     }
      //   }
      print("events");
      print(events);
    });
  }
  Future _pickTime() async{
    TimeOfDay timepck = await showTimePicker(
        context: context,
        initialTime: new TimeOfDay.now());
    if(timepck!=null){
      setState(() {
        _selectedTime = timepck.format(context).toString();
      });
    }
  }

  void getTime() {
    String formattedDateTime = _formatDateTime();
    setState(() {
      timeString = formattedDateTime;
    });
    for(int i=0;i<this.eventList.length;i++)
    {


        var now = new DateTime.now();

        var formatter = new DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);
        String nowTime =  DateFormat('kk:mm').format(now);
        String eventDate = formatter.format(DateTime.parse(eventList[i].eventDate));
        // print(formattedDate);
        //  print(nowTime);

        if(eventDate == formattedDate &&  nowTime == eventList[i].eventTime){
          scheduleAlarm(eventList[i].eventName,eventList[i].eventType,eventList[i].priority);
          break;
        }
      }

  }

  String _formatDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss \nEEE, d MMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    timeString = _formatDateTime();

    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());

    if (eventList == null) {
      eventList = List<AddEvent>();
      updateListView();
    }

    List<int> text = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.black87,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      "  All",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    Text(
                      "  Favourites",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          title: Text('Dashboard'),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ],
        ),
        body: TabBarView(
          children: [
            Container(
              child: FutureBuilder(
                future: dbHelper.getEvents(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AddEvent>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Colors.white,
                          elevation: 2.0,
                          child: ListTile(
                            leading: Builder(builder: (context) {
                              if (this.eventList[index].priority == 'High')
                                return CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Builder(
                                    builder: (context) {
                                      if (this.eventList[index].eventType ==
                                          'Travel')
                                        return Icon(
                                          Icons.card_travel,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Shopping')
                                        return Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Gym')
                                        return Icon(
                                          Icons.fitness_center,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Party')
                                        return Icon(
                                          Icons.party_mode,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Meeting')
                                        return Icon(
                                          Icons.meeting_room,
                                          color: Colors.white,
                                        );
                                      else
                                        return Icon(
                                          Icons.event,
                                          color: Colors.white,
                                        );
                                    },
                                  ),
                                );
                              else
                                return CircleAvatar(
                                  backgroundColor: Colors.lightBlue,
                                  child: Builder(
                                    builder: (context) {
                                      if (this.eventList[index].eventType ==
                                          'Travel')
                                        return Icon(
                                          Icons.card_travel,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Shopping')
                                        return Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Gym')
                                        return Icon(
                                          Icons.fitness_center,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Party')
                                        return Icon(
                                          Icons.party_mode,
                                          color: Colors.white,
                                        );
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Meeting')
                                        return Icon(
                                          Icons.meeting_room,
                                          color: Colors.white,
                                        );
                                      else
                                        return Icon(
                                          Icons.event,
                                          color: Colors.white,
                                        );
                                    },
                                  ),
                                );
                            }),
                            title: Text(this.eventList[index].eventName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: new EdgeInsets.only(
                                        top: 3,
                                        bottom: 5,
                                      ),
                                      child: Text(this
                                          .eventList[index]
                                          .eventDescription),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.date_range),
                                          Text(
                                            this.eventList[index].eventDate,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time),
                                      Text(this.eventList[index].eventTime),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.red,
                                  ),
                                  onTap: () {
                                    // _delete(context, todoList[position]);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // debugPrint("ListTile Tapped");
                              // navigateToDetail(this.todoList[position], 'Edit Todo');
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
              child: Icon(Icons.star),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 350.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/back3.png"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.blue,
                  ),
                  child: Text(
                    timeString,
                    textAlign: TextAlign.start,
                    // Text(timeString,textAlign: TextAlign.start,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 31.0, color: Colors.white),),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {},
                title: Text(
                  'Overdue Events',
                  style: TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: 25,
                  height: 25,
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {},
                title: Text(
                  'Tomorrow Events',
                  style: TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 25,
                  height: 25,
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {},
                title: Text(
                  'Upcoming Events',
                  style: TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 25,
                  height: 25,
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.error),
                onTap: () {},
                title: Text(
                  'About',
                  style: TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightBlue,
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0),
        ),
        floatingActionButton: Container(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          child: AddEventPage(),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))));
                    });
              },
              child: Icon(
                Icons.add,
                size: 30.0,
              ),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  void scheduleAlarm(String eventname,String eventtype,String priority) async {
    
    var  scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 1));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'bell',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('bell'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);


    await flutterLocalNotificationsPlugin.schedule(0,eventname,priority,scheduledNotificationDateTime, platformChannelSpecifics);
  }

}
