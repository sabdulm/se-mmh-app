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

  @override
  Widget build(BuildContext context){
    print(othername+"\n\n");
    var formatter = new DateFormat().add_jm().add_yMMMMd();
    String subt = _msg.latest+"\n\n"+formatter.format(_msg.date);
    if(30<_msg.latest.length){
      String subt = _msg.latest.substring(0,30)+"...\n\n"+formatter.format(_msg.date);
    }
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
      isThreeLine: true,
      onTap: () {
        setState(() {
          if (!_msg.read)
            _msg.read = !_msg.read;
        });
        Route route = MaterialPageRoute(builder: (context)=>ChatScreen(chatkey,name,email,othername,otheremail));
        Navigator.push(context, route);
      },
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
    return new ListView.separated(
      separatorBuilder : (context,index)=> Divider(
        color : Colors.orange
      ),
      itemCount: allmsgs.length,
      itemBuilder: ((context,index)=>Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('chat').where('key',isEqualTo:allmsgs[index]).snapshots(),
          builder: (context,snapshot){
            var newmsg = message(date: DateTime.parse(snapshot.data.documents[0]['last_time']), latest: snapshot.data.documents[0]['latest'],
              read: snapshot.data.documents[0]['read'] || (snapshot.data.documents[0]['lastsender']==email),name: snapshot.data.documents[0]['name']);
            return ChatTile(newmsg,allmsgs[index],chatnames[index],snapshot.data.documents[0]['name']);
          },
        )
      )),
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
         return MessageList(Getchats(email, snapshot.data.documents[0]['inbox']),snapshot.data.documents[0]['inbox']);
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
