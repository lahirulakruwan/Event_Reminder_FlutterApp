import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String timeString;

  void getTime() {
    String formattedDateTime = _formatDateTime();
    setState(() {
      timeString = formattedDateTime;
    });
  }

  String _formatDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss \nEEE, d MMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {

    timeString = _formatDateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());

    List<int> text = [1,2,3,4,5,6,7,8,9,10,11,12,13];

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
                    Icon(Icons.article_rounded,
                    color: Colors.white,),
                    Text("  All",
                    style: TextStyle(fontSize: 17.0,color: Colors.white,),),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star,
                      color: Colors.white,),
                    Text("  Favourites",
                      style: TextStyle(fontSize: 17.0,color: Colors.white,),),
                  ],
                ),
              ),
            ],
          ),
          title: Text('Dashboard'),
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
              for ( var i in text )
              Container(
                child: Card(
                  margin: EdgeInsets.only(top: 10,left: 8,right: 8,),
                  color: Colors.white,
                  child: Container(
                    padding: new EdgeInsets.only(top: 7,bottom: 7),
                    child: ListTile(
                      leading: FlutterLogo(size: 56.0),
                      title: Text('Two-line ListTile',),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: new EdgeInsets.only(top: 3, bottom: 5,),
                                  child: Text('description'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: new EdgeInsets.only(top: 0, bottom: 5,),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {}, icon: Icon(Icons.star, color: Colors.yellow,)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
                                width: 20,
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    Text('2021.05.20',),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time),
                                    Text('10.30'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      trailing: Container(
                        margin: EdgeInsets.all(0),
                          child: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)
                          )),
                    ),
                  ),
                ),
                decoration: new BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black12,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 2.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
              ),
            Divider(),
              ]


              // ListTile(
              //   leading: Icon(Icons.watch_later_rounded),
              //   title: Text('Event name'),
              //   subtitle: Text('Event description'),
              //   trailing: Icon(Icons.more_vert),
              //   onTap: () {},
              // ),
              // Divider(),
              // ListTile(
              //   leading: Icon(Icons.watch_later_rounded),
              //   title: Text('Event name'),
              //   subtitle: Text('Event description'),
              //   trailing: Icon(Icons.more_vert),
              //   onTap: () {},
              // ),
              // Divider(),
              // ListTile(
              //   leading: Icon(Icons.watch_later_rounded),
              //   title: Text('wewe'),
              //   subtitle: Text('Event description'),
              //   trailing: Icon(Icons.more_vert),
              //   onTap: () {},
              // ),
              // Divider(),
            // ],
          ),
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
                  child:
                  Text(
                    timeString,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.mako(
                      textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 31.0, color: Colors.white),
                    ),
                    // Text(timeString,textAlign: TextAlign.start,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 31.0, color: Colors.white),),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {},
                title: Text(
                  'Overdue Events',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 25,
                  height: 25,
                  child: Center(
                    child:Text("1", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {},
                title: Text('Tomorrow Events',style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0
                ),),
                trailing: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 25,
                  height: 25,
                  child: Center(
                    child:Text("1", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_rounded),
                onTap: () {},
                title: Text('Upcoming Events',style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0
                ),),
                trailing: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 25,
                  height: 25,
                  child: Center(
                    child:Text("1", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.error),
                onTap: () {},
                title: Text('About',style: TextStyle(
                  color: Colors.black54,
                    fontSize: 16.0
                ),),
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
              onPressed: () {},
              child: Icon(Icons.add, size: 30.0,),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
