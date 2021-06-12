
import 'package:event_reminder/screens/updateEventScreen.dart';
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
import 'package:fluttertoast/fluttertoast.dart';

import 'EventListFilter/filtered_event_list.dart';
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
  List<AddEvent> FaveventList;
  int upcomingEventsCount = 0;
  int overdueEventsCount = 0;
  int tomorrowEventsCount = 0;
  String _selectedTime = 'Pick Time';
  int count = 0;
  int favCount = 0;


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
          this.count = eventList.length;
        });
      });
    });
  }

  void updateFavListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<AddEvent>> eventList = dbHelper.getFavouriteEvents();
      eventList.then((eventList) {
        setState(() {
          this.FaveventList = eventList;
          this.favCount = eventList.length;
        });
      });
    });
  }

  void updateEventCount() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<int> upcomingEventCounts = dbHelper.getUpcomingEventCount();
      Future<int> overdueEventCounts = dbHelper.getOverdueEventCount();
      Future<int> tomorrowEventCounts = dbHelper.getTomorrowEventCount();

      upcomingEventCounts.then((counts) =>
      {
        setState(() {
          this.upcomingEventsCount = counts;
        })
      });

      overdueEventCounts.then((counts) =>
      {
        setState(() {
          this.overdueEventsCount = counts;
        })
      });

      tomorrowEventCounts.then((counts) =>
      {
        setState(() {
          this.tomorrowEventsCount = counts;
        })
      });
    });
  }
  Future<List<AddEvent>> events;

  refreshList() {
    setState(() {
      events = dbHelper.getEvents();
    });
    updateEventCount();
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


      if(eventDate == formattedDate &&  nowTime == eventList[i].eventTime){
        scheduleAlarm(eventList[i].eventName,eventList[i].eventDate);
        break;
      }
    }
  }

  String _formatDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss \nEEE, d MMM yyyy').format(now);
  }

  deleteEvent(int id){

    AddEvent  delete = AddEvent(id,null, null, null , null, null,null, null);
    var type = dbHelper.deleteEvent(delete);
    return type;
  }

  void toastMessageForDelete(int deleteItemID) {
    deleteEvent(deleteItemID);

    Fluttertoast.showToast(
        msg: 'Event Deleted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightBlue,
        textColor: Colors.white
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Event Deleted !!"),
          content: new Text("You Cannot Get Gack Deleted Event "),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventListScreen() ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void toastMessageForUpdate(int itemId, int favNumber) {
    AddEvent updateFavorite = AddEvent(itemId,null, null, null , null, null,null, favNumber);
    dbHelper.addedToFavorite(updateFavorite);
    Fluttertoast.showToast(
        msg: 'Added to Favorite',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightBlue,
        textColor: Colors.white
    );
    updateListView();
    updateFavListView();
  }


  @override
  Widget build(BuildContext context) {
    timeString = _formatDateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());

    if (eventList == null) {
      eventList = List<AddEvent>();
      updateListView();
      updateEventCount();
      updateFavListView();
    }

    List<int> text = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
    Set<String> savedWords = Set<String>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Image.asset(
            'assets/back2.jpg',
            fit: BoxFit.cover,
          ),
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
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 2.0,
                          child: ListTile(
                            leading: Builder(builder: (context) {
                              return Container(
                                child: CircleAvatar(
                                  radius: 26.0,
                                  backgroundColor: Colors.lightBlue,
                                  child: Builder(
                                    builder: (context) {
                                      if (this.eventList[index].eventType ==
                                          'Travel')
                                        return Image.asset('assets/travel.png');
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Shopping')
                                        return Image.asset(
                                            'assets/shopping.png');
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Gym')
                                        return Image.asset('assets/gym.png');
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Party')
                                        return Image.asset('assets/party.png');
                                      else if (this
                                              .eventList[index]
                                              .eventType ==
                                          'Meeting')
                                        return Image.asset(
                                            'assets/meeting.png');
                                      else
                                        return Image.asset('assets/event.png');
                                    },
                                  ),
                                ),
                              );
                            }),
                            title: Text(this.eventList[index].eventName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            subtitle: Builder(builder: (context) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: new EdgeInsets.only(
                                          top: 3,
                                          bottom: 5,
                                        ),
                                        child: Text(
                                            this
                                                .eventList[index]
                                                .eventDescription,
                                            style: TextStyle(
                                                color: Colors.black54)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Builder(
                                          builder: (context) {
                                            if (this
                                                    .eventList[index]
                                                    .priority ==
                                                'High')
                                              return Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(20)
                                                            )
                                                    ),
                                                    width: 20,
                                                    height: 20,
                                                    child: Center(
                                                      child: Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            else
                                              return Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(20)
                                                            )
                                                    ),
                                                    width: 20,
                                                    height: 20,
                                                    child: Center(
                                                      child: Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.date_range),
                                            Text(
                                                " " +
                                                    this
                                                        .eventList[index]
                                                        .eventDate,
                                                style: TextStyle(
                                                    color: Colors.black54)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Icon(Icons.access_time),
                                            Text(
                                              " " +
                                                  this
                                                      .eventList[index]
                                                      .eventTime,
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 2),
                                        child: Row(
                                          children: [
                                            Text("   "),
                                            Icon(this.eventList[index].favorite.toString() == "1" ? Icons.favorite:Icons.favorite_outline_outlined, color: Colors.red),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              );
                            }),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                PopupMenuButton(

                                  onSelected: (value) {
                                    if (value == 1) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(

                                                child: updateEvent(id:eventList[index].id, name:eventList[index].eventName, description:eventList[index].eventDescription,date:eventList[index].eventDate,time:eventList[index].eventTime,priority:eventList[index].priority,type:eventList[index].eventType),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(12))));
                                          });
                                    }else if(value == 0){
                                      toastMessageForDelete(eventList[index].id);
                                    }else{
                                      toastMessageForUpdate(eventList[index].id, eventList[index].favorite);
                                    }
                                  },
                                  itemBuilder: (context)=>[

                                    PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(
                                                Icons.update,color: Colors.blue,),
                                            Text(" Update Event")
                                          ],
                                        ),
                                      value: 1,
                                    ),
                                    PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(
                                                Icons.delete,
                                                color: Colors.red,),
                                            Text("Delete Event"),
                                          ],
                                        ),

                                      value: 0,
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,),
                                          Text(eventList[index].favorite == 0 ? " Add to favorite": " Unfavorite"),
                                        ],
                                      ),

                                      value: 3,
                                    )
                                  ],
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
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
              child: FutureBuilder(
                future: dbHelper.getFavouriteEvents(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AddEvent>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: favCount,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 2.0,
                          child: ListTile(
                            leading: Builder(builder: (context) {
                              return Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   shape: BoxShape.circle,
                                //   boxShadow: [BoxShadow(
                                //     color: Colors.black54,
                                //     blurRadius: 20.0, // soften the shadow
                                //     spreadRadius: 0.5, //extend the shadow
                                //     offset: Offset(
                                //       5.0, // Move to right 10  horizontally
                                //       5.0, // Move to bottom 10 Vertically
                                //     ),
                                //   )],
                                // ),
                                child: CircleAvatar(
                                  radius: 26.0,
                                  backgroundColor: Colors.lightBlue,
                                  child: Builder(
                                    builder: (context) {
                                      if (this.FaveventList[index].eventType ==
                                          'Travel')
                                        return Image.asset('assets/travel.png');
                                      else if (this
                                          .FaveventList[index]
                                          .eventType ==
                                          'Shopping')
                                        return Image.asset(
                                            'assets/shopping.png');
                                      else if (this
                                          .FaveventList[index]
                                          .eventType ==
                                          'Gym')
                                        return Image.asset('assets/gym.png');
                                      else if (this
                                          .FaveventList[index]
                                          .eventType ==
                                          'Party')
                                        return Image.asset('assets/party.png');
                                      else if (this
                                          .FaveventList[index]
                                          .eventType ==
                                          'Meeting')
                                        return Image.asset(
                                            'assets/meeting.png');
                                      else
                                        return Image.asset('assets/event.png');
                                    },
                                  ),
                                ),
                              );
                            }),
                            title: Text(this.FaveventList[index].eventName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            subtitle: Builder(builder: (context) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: new EdgeInsets.only(
                                          top: 3,
                                          bottom: 5,
                                        ),
                                        child: Text(
                                            this
                                                .FaveventList[index]
                                                .eventDescription,
                                            style: TextStyle(
                                                color: Colors.black54)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Builder(
                                          builder: (context) {
                                            if (this
                                                .FaveventList[index]
                                                .priority ==
                                                'High')
                                              return Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(20)
                                                        )
                                                    ),
                                                    width: 20,
                                                    height: 20,
                                                    child: Center(
                                                      child: Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            else
                                              return Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(20)
                                                        )
                                                    ),
                                                    width: 20,
                                                    height: 20,
                                                    child: Center(
                                                      child: Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.date_range),
                                            Text(
                                                " " +
                                                    this
                                                        .FaveventList[index]
                                                        .eventDate,
                                                style: TextStyle(
                                                    color: Colors.black54)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Icon(Icons.access_time),
                                            Text(
                                              " " +
                                                  this
                                                      .FaveventList[index]
                                                      .eventTime,
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 2),
                                        child: Row(
                                          children: [
                                            Text("   "),
                                            Icon(this.FaveventList[index].favorite.toString() == "1" ? Icons.favorite:Icons.favorite_outline_outlined, color: Colors.red),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              );
                            }),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                PopupMenuButton(

                                  onSelected: (value) {
                                    if (value == 1) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(

                                                child: updateEvent(id:FaveventList[index].id, name:FaveventList[index].eventName, description:FaveventList[index].eventDescription,date:FaveventList[index].eventDate,time:FaveventList[index].eventTime,priority:FaveventList[index].priority,type:FaveventList[index].eventType),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(12))));
                                          });
                                    }else if(value == 0){
                                      toastMessageForDelete(FaveventList[index].id);
                                    }else{
                                      toastMessageForUpdate(FaveventList[index].id, FaveventList[index].favorite);
                                    }
                                  },
                                  itemBuilder: (context)=>[

                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.update,color: Colors.blue,),
                                          Text("Update Event")
                                        ],
                                      ),
                                      value: 1,
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,),
                                          Text(" Delete Event"),
                                        ],
                                      ),

                                      value: 0,
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,),
                                          Text("Favorite"),
                                        ],
                                      ),

                                      value: 3,
                                    )
                                  ],
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
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
                    // image: DecorationImage(
                    //   image: AssetImage("assets/back2.jpg"),
                    //   fit: BoxFit.cover,
                    // ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/logo.gif'),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          timeString,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 17.0),
                          textAlign: TextAlign.start,
                          // Text(timeString,textAlign: TextAlign.start,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 31.0, color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UpComingEventList("overdue")));},
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
                      "$overdueEventsCount",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UpComingEventList("tomorrow")));},
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
                      "$tomorrowEventsCount",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UpComingEventList("upcoming")));},
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
                      "$upcomingEventsCount",
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
          color: Colors.lightBlueAccent,
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
              backgroundColor: Colors.lightBlue,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
  void scheduleAlarm(String eventname,String eventdate) async {

    var _priority;

    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 1));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'bell_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('bell_icon'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);



    await flutterLocalNotificationsPlugin.schedule(0,eventname,eventdate,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }
}
