
import 'package:event_reminder/sqflite/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:event_reminder/model/add_Event_Model.dart';
import 'dart:async';

class updateEvent extends StatefulWidget {
//
final String name, description, date,time,priority,type;
 final int id;
//
   updateEvent({Key key, this.id,this.name,this.description,this.date,this.time,this.priority,this.type}): super (key:key);
  //
  // updateEvent(int id,String name,String description,String date,String time,String priority,String type){
  //   this.id=id;
  //   this.name=name;
  //   this.description=description;
  //   this.date=date;
  //   this.time=time;
  //   this.priority=priority;
  //   this.type=type;
  // }



  @override
  // _UpdateEventPageState createState() => _UpdateEventPageState(id,name,description,date,time,priority,type);
  _UpdateEventPageState createState() => _UpdateEventPageState();

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


class _UpdateEventPageState extends State<updateEvent> {

  // String name, description, date,time,pryory,type;
  // int id;
  //
  //
  //
  // _UpdateEventPageState({this.id,this.name,this.description,this.date,this.time,this.pryory,this.type});
  //
  // String name, description, date,time,priority,type;
  // int id;
  //
  // updateEvent(int id,String name,String description,String date,String time,String priority,String type){
  //   this.id=id;
  //   this.name=name;
  //   this.description=description;
  //   this.date=date;
  //   this.time=time;
  //   this.priority=priority;
  //   this.type=type;
  //
  //
  // }

  TextEditingController controller = TextEditingController();
  final  _formKey  =  GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  String etype  ;
  String _selectedDate ;
  String _selectedTime;

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();

    _selectedDate = widget.date;
    _selectedTime = widget.time;
    etype = widget.type.toString();

  }
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







  // String _selectedDate ;


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
    // else {
    //   _selectedDate = widget.date;
    // }
  }

  Future _pickTime() async{
    TimeOfDay timepck = await showTimePicker(
        context: context,
        initialTime: new TimeOfDay.now());
    if(timepck!=null){
      setState(() {
        _selectedTime = timepck.toString();
      });
    }
  }

  clearName(){
    controller.text = '';
  }
  Updateclick(){

    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      print(eventName);
      print(eventDescription);
      print( _selectedDate);
      print( _selectedTime);
      print(eventVal);
      print(priorityVal);
      AddEvent  _addevent = AddEvent(widget.id,eventName, eventDescription, _selectedDate , _selectedTime, eventVal,priorityVal);
      dbHelper.Update(_addevent);
      clearName();

    }

  }

  String holder = '' ;
  void getDropDownItem(){

    setState(() {
      holder = etype ;
    });
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
                  "Update Event",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:16 ),
                )),
                SizedBox(height: 20,),
                TextFormField(
                  onSaved: (val)=>eventName = val,
                   initialValue: widget.name.toString(),
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
                  onSaved: (val)=>eventDescription = val,
                  initialValue: widget.description.toString(),
                  // onChanged: (String eventdescription){
                  //   getEventdescription(eventdescription);
                  // },
                  validator: (eventdescription)=>(eventdescription.length < 10 ? 'At least 10 characters required':null),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      labelText: 'Enter description'
                  ),
                ),
                SizedBox(height: 20,),
                _dateTimePickerDate(Icons.date_range,_pickDate,_selectedDate),
                SizedBox(height: 20,),
                _dateTimePickerTime(Icons.access_time,_pickTime,_selectedTime),
                SizedBox(height: 30,),
                Column(

                  children: <Widget>[
                    Text(
                        'Select Task Type:',
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
                              // TextFormField(
                              //   initialValue: pryory,
                              // )
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.lightBlue,
                      onPressed: Updateclick,
                      child: Text('Update'),
                    ),
                    FlatButton(
                      color: Colors.lightBlue,
                      child: Text('CANCEL'),
                      onPressed: ()=>Navigator.pop(context),

                    ),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget _dateTimePickerDate(IconData icon,VoidCallback onPressed,String value){
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
                  style:TextStyle(fontSize: 14)),
              // TextFormField(
              //   initialValue: date,
              // )

            ],
          ),
        ));
  }
  Widget _dateTimePickerTime(IconData icon,VoidCallback onPressed,String value){
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
                  style:TextStyle(fontSize: 14)),
              // TextFormField(
              //   initialValue: time,
              // )

            ],
          ),
        ));
  }
}
