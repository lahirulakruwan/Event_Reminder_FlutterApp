import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:event_reminder/model/add_Event_Model.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String EVENTNAME = 'eventName';
  static const String EVENTDESCRIPTION = 'eventDescription';

  static const String EVENTDATE = 'eventDate';
  static const String EVENTTIME = 'eventTime';
  static const String EVENTTYPE = 'eventType';

  static const String PRIORITY = 'priority';
  static const String TABLE = 'AddEvent';
  static const String DB_NAME = 'eventReminder.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE( $ID INTEGER PRIMARY KEY ,$EVENTNAME TEXT,$EVENTDESCRIPTION TEXT,$EVENTDATE TEXT,$EVENTTIME TEXT,$EVENTTYPE TEXT,$PRIORITY TEXT)");
  }

  Future<AddEvent> save(AddEvent event) async {
    var dbclient = await db;
    print(event);
    event.id = await dbclient.insert(TABLE, event.toMap());
    print(event.id);
    return event;
  }

  Future<List<AddEvent>> getEvents() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, EVENTNAME, EVENTDESCRIPTION, EVENTDATE, EVENTTIME, EVENTTYPE, PRIORITY]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");

    List<AddEvent> events = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        events.add(AddEvent.fromMap(maps[i]));
      }
    }
    return events;
  }

  Future<bool> deleteEvent(AddEvent event) async{

    var dbClient = await db;

    var count = await dbClient.rawDelete('DELETE FROM $TABLE WHERE $ID = ?', [event.id]);

    print("safasfaf $count");
   if(count<0){
     return false;
   }else{
     return true;
   }


  }

  Future<AddEvent> Update(AddEvent event) async {
    var dbclient = await db;
    print(event);
    var val = await dbclient.rawQuery('UPDATE $TABLE SET $EVENTNAME = ? , $EVENTDESCRIPTION= ? , $EVENTDATE = ? , $EVENTTIME=? , $EVENTTYPE=? , $PRIORITY = ? WHERE $ID = ? ', [event.eventName,event.eventDescription,event.eventDate,event.eventTime,event.eventType,event.priority,event.id]);
    return event;
  }
}
