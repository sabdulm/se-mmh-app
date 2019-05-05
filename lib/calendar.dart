import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return Calendarstate();
  }
}

class Calendarstate extends State<Calendar>{
  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context){
    return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    child: CalendarCarousel(
      
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
//      markedDates: _markedDate,
      weekFormat: false,
      // markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate,
      daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
    ),
  );
  }
}