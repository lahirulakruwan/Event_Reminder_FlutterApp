import 'package:event_reminder/model/add_Event_Model.dart';
import 'package:event_reminder/sqflite/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UpComingEventList extends StatefulWidget {
  final String eventType;
  const UpComingEventList(this.eventType);

  @override
  _UpComingEventListState createState() => _UpComingEventListState();
}

class _UpComingEventListState extends State<UpComingEventList> {
  var dbHelper = DBHelper();
  List<AddEvent> eventList;
  int count = 0;


  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<AddEvent>> eventList = dbHelper.getEventsByDate(widget.eventType);
      eventList.then((eventList) {
        setState(() {
          this.eventList = eventList;
          this.count = eventList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (eventList == null) {
      updateListView();
    }

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    widget.eventType == "overdue" ? "Overdue Events" : widget.eventType == "upcoming" ? "Upcoming Events" : "Tomorrow Events" ,
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
        title: Text("Events"),
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
          )
        ],
      ),

    ),
    );
  }
}
