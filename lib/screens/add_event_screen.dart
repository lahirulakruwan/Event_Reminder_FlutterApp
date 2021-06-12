import 'package:event_reminder/sqflite/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:event_reminder/model/add_Event_Model.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'event_list_screen.dart';

class AddEventPage extends StatefulWidget {


  @override
  _AddEventPageState createState() => _AddEventPageState();

}

class Event{
  const Event(this.name,this.icon);
  final String name;
  final Icon icon;
}

class Priority{
  const Priority(this.name,this.icon);
  final String name;
  final Icon icon;
}


class _AddEventPageState extends State<AddEventPage> {

  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  final  _formKey  =  GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  List<Event> Events =<Event>[
    const Event('Travel',Icon(Icons.card_travel,color:  const Color(0xFF82B1FF),)),
    const Event('Shopping',Icon(Icons.shopping_cart_outlined,color:  const Color(0xFF82B1FF),)),
    const Event('Gym',Icon(Icons.fitness_center,color:  const Color(0xFF82B1FF),)),
    const Event('Party',Icon(Icons.party_mode,color:  const Color(0xFF82B1FF),)),
    const Event('Meeting',Icon(Icons.meeting_room,color:  const Color(0xFF82B1FF),)),
    const Event('Others',Icon(Icons.event,color:  const Color(0xFF82B1FF),)),
  ];

  List<Priority> priorities =<Priority>[
    const Priority('High',Icon(Icons.priority_high,color:  const Color(0xFFB71C1C),)),
    const Priority('Low',Icon(Icons.low_priority,color:  const Color(0xFFFFEB3B),)),
  ];



   @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
  }


  String _selectedDate = 'Pick date';
  String _selectedTime = 'Pick Time';

  String eventName,eventDescription,eventType;

  String eventVal;
  Event defaultEventVal;


  String priorityVal;
  Priority defaultPriorityVal;

  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now().add(Duration(days: -365)),
      lastDate : new DateTime.now().add(Duration(days: 365)));
   if(datepick != null ) setState((){
      _selectedDate = datepick.toString();
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

 clearName(){
    controller.clear();
    controller1.clear();
 }

 void toastMessage(){
   Fluttertoast.showToast(
       msg: 'Event Inserted Successfully',
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       backgroundColor: Colors.lightBlue,
       textColor: Colors.white
   );

 }

  void validate(){

    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
        print(eventName);
        print(eventDescription);
        print( _selectedDate);
        print( _selectedTime);
        print(eventVal);
        print(priorityVal);
        var formatter = new DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(DateTime.parse(_selectedDate));
        AddEvent  _addevent = AddEvent(null,eventName, eventDescription, formattedDate , _selectedTime, eventVal,priorityVal);
        dbHelper.save(_addevent);
        toastMessage();
        clearName();

    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child:Form(
         key: _formKey,
         child : Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(child: Text(
              "Add new Event",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize:16 ),
            )),
            SizedBox(height: 20,),
           TextFormField(
              controller:  controller,
              onSaved: (val)=>eventName = val,
              // onChanged: (String eventname){
              //   getEventName(eventname);
              // },
              validator: (eventname)=>(eventname.length==0 ? 'This field is required':null),
              decoration: InputDecoration(
              border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              labelText: 'Enter event name'
             ),
             ),
            SizedBox(height: 20,),
            TextFormField(
                controller: controller1,
                onSaved: (val)=>eventDescription = val,
              validator: (eventdescription)=>(eventdescription.length < 10 ? 'At least 10 characters required':null),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  labelText: 'Enter description'
              ),
            ),
            SizedBox(height: 20,),
            _dateTimePicker(Icons.date_range,_pickDate,_selectedDate),
            SizedBox(height: 20,),
            _dateTimePicker(Icons.access_time,_pickTime,_selectedTime),
            SizedBox(height: 30,),
            Column(
              children: <Widget>[
                Text(  'Select Task Type:',
                           style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                           textAlign:TextAlign.start ),
                SizedBox(height: 10,),
               DropdownButton<Event>(

                     items: Events.map((Event event) {
                       return  DropdownMenuItem<Event>(
                      value: event,
                      child: Row(
                        children: <Widget>[
                          event.icon,
                          SizedBox(width: 10,),
                          Text(
                            event.name,
                            style:  TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      eventVal = value.name;
                      defaultEventVal = value;
                    });
                  },
                  value:  defaultEventVal ,
                ),
                SizedBox(height: 30,),
                Text(
                    'Select Priority:',
                    style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                    textAlign:TextAlign.start ),
                SizedBox(height: 10,),
                DropdownButton<Priority>(
                  items: priorities.map((Priority priority) {
                    return  DropdownMenuItem<Priority>(
                      value: priority,
                      child: Row(
                        children: <Widget>[
                          priority.icon,
                          SizedBox(width: 10,),
                          Text(
                            priority.name,
                            style:  TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      priorityVal = value.name;
                      defaultPriorityVal = value;
                    });
                  },
                  value:  defaultPriorityVal ,
                ),
               ],
            ),
            SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              color: Colors.red,
              child: Text('CANCEL'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventListScreen() ),
                );
              },
            ),
            FlatButton(
                color: Colors.lightBlue,
                onPressed: validate,
                child: Text('ADD'),
            ),

          ],
        ),
          ],
        ),
      )
      ),
    );
  }

 Widget _dateTimePicker(IconData icon,VoidCallback onPressed,String value){
    return FlatButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child:Padding(
          padding: const EdgeInsets.only(left:12.0),
          child: Row(
            children: [
              Icon(icon,
                color:Theme.of(context).accentColor ,size: 30,),
              SizedBox(
                width: 12,
              ),
              Text(value,
                  style:TextStyle(fontSize: 14))
            ],
          ),
        ));
 }
}
