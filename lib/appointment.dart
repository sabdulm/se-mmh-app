import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ApointmentRequestPage extends StatefulWidget{
  String chatkey;
  String name;
  String email;
  String othername;
  String otheremail;
  ApointmentRequestPage(this.chatkey, this.name, this.email, this.othername, this.otheremail);

  @override
  State<StatefulWidget> createState(){
    return ApointmentRequestState(chatkey, name, email, othername, otheremail);
  }
}

class ApointmentRequestState extends State<ApointmentRequestPage>{
  String chatkey;
  String name;
  String email;
  String othername;
  String otheremail;
  DateTime dob = DateTime.now();
  String dobstr = "Tap to Select a Date";
  String detail = "";
  final TextEditingController controller =
      new TextEditingController();
  ApointmentRequestState(this.chatkey, this.name, this.email, this.othername, this.otheremail);
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2030));
      if (picked != null && picked != DateTime.now())
      setState(() {
        dob = picked;
        String dateSlug ="${dob.year.toString()}-${dob.month.toString().padLeft(2,'0')}-${dob.day.toString().padLeft(2,'0')}";
        dobstr = dateSlug;
      });
  }
  @override
  Widget build (BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Book an Appointment with "+othername),
      ),
      body: new Container(
        padding: const EdgeInsets.only(top: 100.0, left: 25.0, right: 25.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
            bottomLeft: const Radius.circular(10.0),
            bottomRight: const Radius.circular(10.0),
          )
        ),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new RaisedButton(
                onPressed: () async{
                  await _selectDate(context);
                  setState(() {
                   dobstr = dobstr; 
                   dob = dob;
                  });
                  },
                child: new Text(dobstr),
              ),
              new Flexible(
                child: new Container(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0,bottom: 5.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                      bottomLeft: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0),
                    )
                  ), 
                 child : new TextField(
                    controller: controller,
                    decoration: new InputDecoration.collapsed(
                      hintText: "Deatils, Location etc."
                    ),
                  ),
                )
              ),
              new RaisedButton(
                onPressed: () async{
                  bool newone = false;
                  detail = controller.text;
                  String datenow = DateTime.now().toString();
                  print(datenow+detail+" HEREEE");
                  await Firestore.instance.runTransaction((transaction) async{
                    CollectionReference ref = await Firestore.instance.collection('chat');
                    QuerySnapshot qs = await ref.where('key',isEqualTo: chatkey).getDocuments();
                    newone = qs.documents.length==0;
                  });
                  print(newone);
                  if(newone){
                    await Firestore.instance.runTransaction((transaction) async{
                      CollectionReference ref = await Firestore.instance.collection('users');
                      QuerySnapshot qs = await ref.where('email',isEqualTo:email).getDocuments();
                      String user1 = qs.documents[0]['user'];
                      DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(user1));
                      await transaction.update(freshsnap.reference, {
                        'inbox': FieldValue.arrayUnion([otheremail])
                      });
                    });
                    await Firestore.instance.runTransaction((transaction) async{
                      CollectionReference ref = await Firestore.instance.collection('users');
                      QuerySnapshot qs = await ref.where('email',isEqualTo:otheremail).getDocuments();
                      String user1 = qs.documents[0]['user'];
                      DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(user1));
                      await transaction.update(freshsnap.reference, {
                        'inbox': FieldValue.arrayUnion([email])
                      });
                    });
                    await Firestore.instance.runTransaction((transaction) async{
                      await transaction.set(Firestore.instance.collection('chat').document(chatkey), {
                        'key' : chatkey,
                        'last_time' : datenow,
                        'lastsender' : email,
                        'latest' : detail,
                        'read' : false,
                        'messages': [chatkey+datenow]
                      });
                    });
                    await Firestore.instance.runTransaction((transaction) async{
                    await transaction.set(Firestore.instance.collection('message').document(chatkey+datenow), {
                        'key' : chatkey+datenow,
                        'message' : detail,
                        'receiver' : otheremail,
                        'receiver_name': othername,
                        'sender' : email,
                        'sender_name' : name,
                        'time' : datenow,
                        'appointment': dob.toString()
                    });
                  });
                  }
                  else{
                    await Firestore.instance.runTransaction((transaction) async{
                      DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('chat').document(chatkey));
                      await transaction.update(freshsnap.reference,{
                        'messages': FieldValue.arrayUnion([chatkey+datenow]),
                        'read' : false,
                        'last_time' : datenow,
                        'lastsender' : email,
                        'latest' : detail
                      });
                    });
                    print("FIRST AWAIT"+chatkey);
                  await Firestore.instance.runTransaction((transaction) async{
                    await transaction.set(Firestore.instance.collection('message').document(chatkey+datenow), {
                        'key' : chatkey+datenow,
                        'message' : detail,
                        'receiver' : otheremail,
                        'receiver_name': othername,
                        'sender' : email,
                        'sender_name' : name,
                        'time' : datenow,
                        'appointment': dob.toString()
                    });
                  });
                  }
                  print("REQUEST SENTTTT");
                  Fluttertoast.showToast(msg: "Request Sent Successfully. ");
                  controller.clear();
                },
                child: new Text("Done"),
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}