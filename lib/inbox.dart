import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';
import 'chat.dart';
import 'dart:developer';
import 'login.dart';

var email = 'hadi@gmail.com';
var name = 'Hadi Q';

class ChatTile extends StatefulWidget{
  message _msg;
  String chatkey;
  String otheremail;
  String othername;

  ChatTile(this._msg,this.chatkey, this.otheremail, this.othername);

  @override
  State<StatefulWidget> createState() {
    return ChatTileState(_msg,chatkey,otheremail,othername);
  }
}

class ChatTileState extends State<ChatTile>{
  message _msg;
  String chatkey;
  String otheremail;
  String othername;

  ChatTileState(this._msg,this.chatkey,this.otheremail, this.othername);
  String TranslateDate(DateTime date){
    DateTime now = DateTime.now();
    final difference = now.difference(date).inDays;
    var formatter = new DateFormat().add_jm();
    if(difference <1){
      return "Today "+formatter.format(date);
    }
    else if (difference<2){
      return "Yesterday "+formatter.format(date);
    }
    else if(difference<7){
      var formatter2 = new DateFormat('EEEE');
      return formatter2.format(date)+" "+formatter.format(date);
    }
    else if(difference<365){
      var formatter2 = new DateFormat().add_MMMd();
      return formatter2.format(date)+" "+formatter.format(date);      
    }
    else{
      var formatter2 = new DateFormat().add_yMMMd().add_jm();
      return formatter2.format(date);
    }
  }
  @override
  Widget build(BuildContext context){
    // print(othername+"\n\n");
    var formatter = new DateFormat().add_jm().add_yMMMMd();
    String time = TranslateDate(_msg.date);
    String subt = "\n"+_msg.latest;
    if(20<_msg.latest.length){
      subt = "\n"+_msg.latest.substring(0,20)+"...";
    }
    print(subt+_msg.latest.length.toString());
    Text nem = Text(_msg.name);
    Text mesg = Text(subt);
    if(_msg.read==false){
      nem = Text(_msg.name, style: TextStyle(fontWeight: FontWeight.bold),);
      mesg = Text(subt, style: TextStyle(fontWeight: FontWeight.bold),);
    }
    return ListTile(
      leading: CircleAvatar(
        child: Text(_msg.name[0]) //Can add profile picture here too
      ),
      title: nem,
      subtitle: mesg,
      trailing: new Text(time),
      isThreeLine: true,
      onTap: () {
        setState(() {
          if (!_msg.read)
            Firestore.instance.collection('chat').document(chatkey).updateData({'read': true});
            _msg.read = true;
        });
        Route route = MaterialPageRoute(builder: (context)=>ChatScreen(chatkey,name,email,othername,otheremail));
        Navigator.push(context, route);
      },
    );
  }
}

class TempState extends StatefulWidget{
  message _msg;
  String chatkey;
  String otheremail;
  String othername;

  TempState(this._msg,this.chatkey,this.otheremail,this.othername);
  @override
  State<StatefulWidget> createState(){
    return TempStatestate(_msg,chatkey,otheremail,othername);
  }
}


class TempStatestate extends State<TempState>{
  message _msg;
  String chatkey;
  String otheremail;
  String othername;

  TempStatestate(this._msg,this.chatkey,this.otheremail,this.othername);
  @override
  Widget build (BuildContext context){
    var clr = Colors.blue.shade100;
    if(!_msg.read){
      clr = Colors.white;
    }
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').where('email',isEqualTo:otheremail).snapshots(),
        builder: (context,snapshot){
          if (snapshot.data!=null){
            _msg.name = snapshot.data.documents[0]['name'];
            othername = _msg.name;
            return ChatTile(_msg, chatkey, otheremail, othername);
          }
          else{
            return new CircularProgressIndicator();
          }
        },
      ),
      decoration: new BoxDecoration(
        color: clr,
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
            bottomLeft: const Radius.circular(10.0),
            bottomRight: const Radius.circular(10.0),
          )
      ),
    );
  }
  
}

class MessageList extends StatefulWidget{
  final List<String> allmsgs;
  var chatnames;

  MessageList(this.allmsgs,this.chatnames);
  
  @override
  State<StatefulWidget> createState(){
    return MessageListState(allmsgs,chatnames);
  }

}


class MessageListState extends State<MessageList>{
  final List<String> allmsgs;
  var chatnames;

  MessageListState(this.allmsgs,this.chatnames);
  @override
  Widget build (BuildContext context){
    return new Container(
      child: ListView.builder(
        // separatorBuilder : (context,index)=> Divider(
        //   color : Colors.blue.shade100
        // ),
        itemCount: allmsgs.length,
        itemBuilder: ((context,index)=>Container(
          padding: EdgeInsets.symmetric(vertical: 0.0),
          child: StreamBuilder(
            stream: Firestore.instance.collection('chat').where('key',isEqualTo:allmsgs[index]).snapshots(),
            builder: (context,snapshot){
              if(snapshot.data!=null){
                var newmsg = message(date: DateTime.parse(snapshot.data.documents[0]['last_time']), latest: snapshot.data.documents[0]['latest'],
                  read: snapshot.data.documents[0]['read'] || (snapshot.data.documents[0]['lastsender']==email),name: "Place Holder");
                return TempState(newmsg,allmsgs[index],chatnames[index],"Place Holder");
              }
              else{
                return new CircularProgressIndicator();
              }
            },
          )
        )),
      ),
      decoration: new BoxDecoration(
        color: Colors.blue.shade50
      ),
    );
  }
}


class InboxPage extends StatefulWidget{
  String name1;
  String email1;

  InboxPage(this.name1,this.email1);

  @override
  InboxPagescreen createState() {
    name = name1;
    email = email1;
    return InboxPagescreen(); 
  }
}

class InboxPagescreen extends State<InboxPage>{

  List<message> listings;
	@override
	Widget build (BuildContext ctxt) {
    // print("hereeee\n\n"+listings.toString());
      // print("listings[0].latest+\n\n");
      return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text("Inbox"),
			),
			body: StreamBuilder(
        stream: Firestore.instance.collection('users').where('email',isEqualTo:email).snapshots(),
        builder: (context,snapshot){
          if (snapshot.data!=null){
            return MessageList(Getchats(email, snapshot.data.documents[0]['inbox']),snapshot.data.documents[0]['inbox']);
          }
          else{
            return new CircularProgressIndicator();
          }
        },
      )
      //MessageList(listings), 
		);		
	}
}


List<String> Getchats(email,list){
  List<String> toret = [];
  for(var i=0; i<list.length; i++){
    // print(list[i]+'\n\n\n');
    List<String> temp = [email,list[i]];
    temp.sort((a, b) => a.toUpperCase().compareTo(b.toUpperCase()));
    toret.add(temp[0]+temp[1]);
  }
  return toret;
}

class message {
	message({this.name,this.latest,this.read, this.date});
	String name;
	String latest;
	bool read;
  DateTime date;
}

