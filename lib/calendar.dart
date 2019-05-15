import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget{
  List<DateTime> events;
  Calendar(this.events);
  @override
  State<StatefulWidget> createState(){
    return Calendarstate(events);
  }
}

class Calendarstate extends State<Calendar>{
  List<DateTime> events;
  DateTime _currentDate = DateTime.now();
  Calendarstate(this.events);  

  @override
  Widget build(BuildContext context){
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        markedDates: events,
        markedDateShowIcon: true,
        markedDateWidget: new Icon(Icons.people),
        markedDateColor: Colors.blue,
        thisMonthDayBorderColor: Colors.grey,
        weekFormat: false,
        height: 420.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: true, /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }
}


class Tempclass extends StatefulWidget{
  List<dynamic> events;
  Tempclass(this.events);

  @override
  State<StatefulWidget> createState(){
    return Tempstate(events);
  }
}

class Tempstate extends State<Tempclass>{
  List<dynamic> events;
  Tempstate(this.events);

  List<DateTime> ToDate(List<dynamic> es){
    List<DateTime> ret = [];
    for(int i=0; i<es.length; i++){
      if(events.contains(es[i]['key'])){
        ret.add(DateTime.parse(es[i]['date']));
      }
    }
    return ret;
  }

  @override
  Widget build(BuildContext context){
    return new StreamBuilder(
      stream: Firestore.instance.collection('appointments').snapshots(),
      builder: (context,snapshot){
        if(snapshot.data!=null){
          return Calendar(ToDate(snapshot.data.documents));
        }
      },
    );
  }
}

class AppointmentRenderer extends StatefulWidget{
  String email;
  AppointmentRenderer(this.email);

  @override
  State<StatefulWidget> createState(){
    return AppointState(email);
  }
}

class AppointState extends State<AppointmentRenderer>{
  String email;
  AppointState(this.email);

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Calendar"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').where('email',isEqualTo:email).snapshots(),
        builder: (context,snapshot){
          if(snapshot.data!=null){
            return Tempclass(snapshot.data.documents[0]['appointment']);
          }
          else{
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
