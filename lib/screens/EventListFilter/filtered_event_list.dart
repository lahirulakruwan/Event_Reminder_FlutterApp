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
          print(this.eventList.length);
          this.count = eventList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.eventType);
    if (eventList == null) {
      updateListView();
    }

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
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
          )
        ],
      ),

    ),
    );
  }
}
