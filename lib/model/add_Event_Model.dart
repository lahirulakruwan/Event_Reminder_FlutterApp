class AddEvent{
  int id;
  String eventName;
  String eventDescription;
  String eventDate;
  String eventTime;
  String eventType;
  String priority;

  AddEvent(this.id,this.eventName,this.eventDescription,this.eventDate,this.eventTime,this.eventType,this.priority);



  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' : id,
      'eventName' : eventName,
      'eventDescription' : eventDescription,
      'eventDate' : eventDate,
      'eventTime' : eventTime,
      'eventType' : eventType,
      'priority' : priority,
    };
   return map;
  }

  AddEvent.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    eventName = map['eventName'];
    eventDescription = map['eventDescription'];
    eventDate = map['eventDate'];
    eventTime = map['eventTime'];
    eventType = map['eventType'];
    priority = map['priority'];
  }

}