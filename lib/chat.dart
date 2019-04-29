import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'inbox.dart';

// var email = "hadi@gmail.com";
// String name = "Hadi";
var formatter = new DateFormat().add_jm().add_yMMMMd();
class Messagetile extends StatelessWidget{
  String msgkey;
  String chatee;

  Messagetile(this.msgkey,this.chatee);

  List<Widget> SentMessageTile(_msg){
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
                  child: new Text(_msg.msg),
                  
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
              child: new Text(name[0]),
            ),
          )
        ],
      )

    ];
  }

  List<Widget> ReceivedMessageTile(_msg){
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
                  child: new Text(_msg.msg),
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
          return new Row(
            children: email == newchatmsg.email?
              SentMessageTile(newchatmsg):
              ReceivedMessageTile(newchatmsg),
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
                setState(() {
                  var newtext = controller.text;
                  var datenow = DateTime.now().toString();
                  Firestore.instance.runTransaction((transaction) async{
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
                  Firestore.instance.runTransaction((transaction) async{
                    DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('chat').document(chatkey));
                    await transaction.update(freshsnap.reference,{
                    'messages': FieldValue.arrayUnion([chatkey+datenow]),
                    'read' : false,
                    'last_time' : datenow,
                    'lastsender' : email,
                    'latest' : newtext
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
        Navigator.of(context).pushNamedAndRemoveUntil('inbox', ModalRoute.withName('drawer'));
      },
      child : new Scaffold(
        appBar: new AppBar(
          title: Text(othername),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() {
              Navigator.of(context).pushNamedAndRemoveUntil('inbox', ModalRoute.withName('drawer'));
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
                      var msgs = snapshot.data.documents[0]['messages'];
                      return Msgsbuilder(msgs);
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




