import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:event_reminder/model/add_Event_Model.dart';

class DBHelper{

  static Database _db;
  static const String ID ='id';
  static const String EVENTNAME = 'eventName';
  static const String EVENTDESCRIPTION = 'eventDescription' ;
  static const String EVENTDATE =  'eventDate';
  static const String EVENTTIME = 'eventTime';
  static const String EVENTTYPE =  'eventType' ;
  static const String PRIORITY =  'priority';
  static const String TABLE = 'AddEvent';
  static const String DB_NAME = 'eventReminder.db';

  Future<Database> get db async{

    if( _db != null){

      return _db;
    }

    _db = await initDb();
    return _db;

  }

  initDb() async{
    io.Directory  documentDirectory =  await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,DB_NAME);
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db,int version) async{
    
    await db.execute("CREATE TABLE $TABLE( $ID INTEGER PRIMARY KEY ,$EVENTNAME TEXT,$EVENTDESCRIPTION TEXT,$EVENTDATE TEXT,$EVENTTIME TEXT,$EVENTTYPE TEXT,$PRIORITY TEXT)");
  }

  Future<AddEvent> save(AddEvent event)  async{
     var dbclient = await db;
     print(event);
     event.id = await dbclient.insert(TABLE, event.toMap());
     print(event.id);
     return event;
  }
}




