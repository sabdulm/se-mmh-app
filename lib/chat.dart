import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'inbox.dart';
import 'appointment.dart';

// var email = "hadi@gmail.com";
// String name = "Hadi";
var formatter = new DateFormat().add_yMMMMd();
bool newchat = false;


String ckey,nem,emel,odernem,oderemel;

class Messagetile extends StatelessWidget{
  String msgkey;
  String chatee;

  Messagetile(this.msgkey,this.chatee);

  Widget Sentaptrqst(_msg,apt){
    apt = formatter.format(DateTime.parse(apt));
    return new Container(
      child: new Column(
        children: <Widget>[
          new Center(
            child: new Container(
            child: new Text("Appointment Request", style: new TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w900),),
          ),
          ),
          new Container(
            child: new Text("Date: "+apt, style: new TextStyle(fontWeight: FontWeight.w900),),
          ),
          new Text("Detail: "+_msg.msg)
        ],
      ),
    );
  }

  List<Widget> SentMessageTile(_msg,apt){
    var length = _msg.msg.length;
    length = 3*length;

    return <Widget>[
      new Expanded(
        child: new Container(
          padding: const EdgeInsets.only(left: 25.0),
          child : new Container(
            padding: const EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
            child : new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: apt!=''?
                  Sentaptrqst(_msg,apt):
                  new Text(_msg.msg),
                  
                )
              ],
            ),
            decoration: new BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
              )
            ),
          )
        )
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: new CircleAvatar(
              child: new Text(name[0],
              style: TextStyle(
                color: Colors.black
              ),),
              backgroundColor: Colors.orange.shade100,
            ),
          )
        ],
      )

    ];
  }

Widget Recvaptrqst(_msg,apt_,context){
  String apt = formatter.format(DateTime.parse(apt_));
  return new Container(
    child: new Column(
      children: <Widget>[
        new Center(
            child: new Container(
            child: new Text("Appointment Request", style: new TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w900),),
          ),
        ),
        new Container(
          child:  new Text("Date: "+apt, style: new TextStyle(fontWeight: FontWeight.w900),),
        ),
        new Text("Detail: "+_msg.msg),
        new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text("Accept"),
              color: Colors.green.shade300,
              onPressed: () async{
                String datenow = DateTime.now().toString();
                await Firestore.instance.runTransaction((transaction) async{
                  await transaction.set(Firestore.instance.collection('appointments').document(ckey+datenow), {
                      'key' : ckey+datenow,
                      'detail' : _msg.msg,
                      'date' : apt_,
                      'user1' : nem,
                      'user2' : odernem,
                      'email1' : emel,
                      'email2' : oderemel
                  });
                });
                await Firestore.instance.runTransaction((transaction) async{
                  CollectionReference ref = await Firestore.instance.collection('users');
                  QuerySnapshot qs = await ref.where('email',isEqualTo:emel).getDocuments();
                  String user1 = qs.documents[0]['user'];
                  DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(user1));
                  await transaction.update(freshsnap.reference, {
                    'appointment': FieldValue.arrayUnion([ckey+datenow])
                  });
                });
                await Firestore.instance.runTransaction((transaction) async{
                  CollectionReference ref = await Firestore.instance.collection('users');
                  QuerySnapshot qs = await ref.where('email',isEqualTo:oderemel).getDocuments();
                  String user1 = qs.documents[0]['user'];
                  DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(user1));
                  await transaction.update(freshsnap.reference, {
                    'appointment': FieldValue.arrayUnion([ckey+datenow])
                  });
                });
                String nmsg = "This message was automatically generated for an appointment: "+_msg.msg+"\nSTATUS: ACCEPTED\nCheck Calendar for your appointments";
                await Firestore.instance.runTransaction((transaction) async{
                  DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('message').document(msgkey));
                  await transaction.update(freshsnap.reference,{
                    'message' : nmsg,
                    'appointment' : ''
                  });
                });
              },
            ),
            new RaisedButton(
              child: new Text("Reject"),
              color: Colors.red.shade300,
              onPressed: () async{
                String nmsg = "This message was automatically generated for an appointment: "+_msg.msg+"\nSTATUS: REJECTED";
                await Firestore.instance.runTransaction((transaction) async{
                  DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('message').document(msgkey));
                  await transaction.update(freshsnap.reference,{
                    'message' : nmsg,
                    'appointment' : ''
                  });
                });
              },
            ),
            new RaisedButton(
              child: new Text("Postpone"),
              color: Colors.yellow.shade300,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context)=>ApointmentRequestPage(ckey, nem, emel, odernem, oderemel))
                );
              },
            )
          ],
        )
      ],
    ),
  );
}

  List<Widget> ReceivedMessageTile(_msg,apt,context){
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: new CircleAvatar(
              child: new Text(
                _msg.chatee[0],
                style: TextStyle(
                  color: Colors.black
                ),
                ),
              backgroundColor: Colors.blue.shade100,
            ),
          )
        ],
      ),
      new Expanded(
        child: new Container(
          padding: const EdgeInsets.only(right: 25.0),
          child : new Container(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            child : new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: apt!=''?
                  Recvaptrqst(_msg,apt,context):
                  new Text(_msg.msg),
                )
              ],
            ),
            decoration: new BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
              )
            ),
          )
        )
      )
    ];
  }
  @override
  Widget build(BuildContext context){
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: StreamBuilder(
        stream: Firestore.instance.collection('message').where('key',isEqualTo:msgkey).snapshots(),
        builder: (context,snapshot){
          if (snapshot.data!=null){
          print(chatee+msgkey+snapshot.data.documents.toString());
          var newchatmsg = Chatmessage(chatee: chatee, msg: snapshot.data.documents[0]['message'],email: snapshot.data.documents[0]['sender'],
          date:DateTime.parse(snapshot.data.documents[0]['time']));
          String apt = snapshot.data.documents[0]['appointment'];
          if (apt==null){
            apt = '';
          }
          return new Row(
            children: email == newchatmsg.email?
              SentMessageTile(newchatmsg,apt):
              ReceivedMessageTile(newchatmsg,apt,context),
          );
        }
        else{
          return new CircularProgressIndicator();
        }
        },
      )
    );
  }
}


class ChatScreen extends StatefulWidget{
  String chatkey;
  String name;
  String email;
  String othername;
  String otheremail;
  ChatScreen(this.chatkey, this.name,this.email,this.othername,this.otheremail);

  @override
  State<StatefulWidget> createState() {
    ckey = chatkey;
    nem = name;
    emel = email;
    odernem = othername;
    oderemel = otheremail;
    return ChatScreenState(chatkey,name,email,othername,otheremail);
  }
}

class ChatScreenState extends State<ChatScreen>{
  String chatkey;
  String name;
  String otheremail;
  String email;
  String othername;
  ChatScreenState(this.chatkey,this.name,this.email,this.othername,this.otheremail);
  final TextEditingController controller =
      new TextEditingController();

  Widget Msgsbuilder(_msgs){
    Iterable _msgs_iter = _msgs.reversed;
    _msgs = _msgs_iter.toList();
    return new ListView.builder(
      reverse: true,
      itemCount: _msgs.length,
      itemBuilder: ((context,index)=>Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: listbuilder(index,_msgs),
      )),
    );
  }
  Messagetile listbuilder(int i,_msgs){
    return Messagetile(_msgs[i],othername);
  }
  Widget Textcomposer(){
    return new Container(
      margin: new EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(Icons.photo_camera), 
              onPressed: () {},
            )
          ),
          new Flexible(
            child: new TextField(
              controller: controller,
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: (){
                setState(() async{
                  var newtext = controller.text;
                  var datenow = DateTime.now().toString();
                  if(newchat){
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
                        'latest' : newtext,
                        'read' : false,
                        'messages': [chatkey+datenow]
                      });
                    });
                    newchat = false;
                  }
                  else{
                    await Firestore.instance.runTransaction((transaction) async{
                      DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('chat').document(chatkey));
                      await transaction.update(freshsnap.reference,{
                        'messages': FieldValue.arrayUnion([chatkey+datenow]),
                        'read' : false,
                        'last_time' : datenow,
                        'lastsender' : email,
                        'latest' : newtext
                      });
                    });
                  }
                  await Firestore.instance.runTransaction((transaction) async{
                    await transaction.set(Firestore.instance.collection('message').document(chatkey+datenow), {
                        'key' : chatkey+datenow,
                        'message' : newtext,
                        'receiver' : otheremail,
                        'receiver_name': othername,
                        'sender' : email,
                        'sender_name' : name,
                        'time' : datenow
                    });
                  });
                  controller.clear();
                });
              },
            )
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return new WillPopScope(
      onWillPop: (){
        // Navigator.of(context).pushNamedAndRemoveUntil('inbox', ModalRoute.withName('home'));
        Navigator.pop(context);
      },
      child : new Scaffold(
        appBar: new AppBar(
          title: Text(othername),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() {
              Navigator.of(context).pushNamedAndRemoveUntil('inbox', ModalRoute.withName('home'));
            },
          )
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child : StreamBuilder(
                  stream: Firestore.instance.collection('chat').where('key',isEqualTo:chatkey).snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.data!=null){
                      if(snapshot.data.documents.length>0){
                        var msgs = snapshot.data.documents[0]['messages'];
                        return Msgsbuilder(msgs);
                      }
                      else{
                        newchat = true;
                        return new Center(
                          child: new Text("Send a message and start conversation!"),
                        );
                      }
                    }
                    else{
                      return new Text('Loading...');
                    }
                  },
                )
              ),
              new Divider(height: 1.0,),
              new Container(
                child: Textcomposer(),
              )
            ],
          ),
        ),
      )
    );
  }
}

class Chatmessage {
	Chatmessage({this.chatee,this.email,this.msg, this.date});
	String chatee;
	String email;
	String msg;
  DateTime date;
}




