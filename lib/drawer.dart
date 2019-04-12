// import 'package:flutter/material.dart';

// class MyHomePage extends StatelessWidget {
// 	Widget _listItemBuilder (BuildContext context , int index){
// 		return Stack(
// 			children: <Widget>[
// 				new Image.network(listings[index].photo_url),
// 				Center(
// 					child: Text(listings[index].name)
// 				),
// 			],
// 		);
// 		// return Text(listings[index].name);
// 	}


// 	@override
// 	Widget build (BuildContext ctxt) {
// 		return new Scaffold(
// 			drawer: new DrawerOnly(),
// 			appBar: new AppBar(
// 				title: new Text("Drawer Demo"),
// 			),
// 			body: new ListView.builder(
// 					itemCount: listings.length,
// 					itemExtent: 100.0,
// 					itemBuilder: _listItemBuilder,

// 				), //<-------add lists here!!!
// 			floatingActionButton: FloatingActionButton(
// 				tooltip: 'Increment',
// 				child: Icon(Icons.photo_filter),
// 			),
// 		);
// 	}
// }


// class advertisement {
// 	const advertisement({this.name,this.photo_url,this.description});
// 	final String name;
// 	final String photo_url;
// 	final String description;
// }

// final List<advertisement> listings = <advertisement>[
// 	advertisement(name: 'bungla' , photo_url: 'https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg',description:'wow what a house'),
// 	advertisement(name: 'bungla1' , photo_url: 'https://westvancouver.ca/sites/default/files/styles/grid-9/public/coachhouse_0.jpg?itok=G4DGtlrw',description:'shit house'),
// 	advertisement(name: 'bungla2' , photo_url: 'https://eieihome.com/articles/wp-content/uploads/2018/04/architecture-building-driveway-186077.jpg',description:'Beautiful'),
// ];

// class DrawerOnly extends StatelessWidget {
//   @override
//   Widget build (BuildContext ctxt) {
//     return new Drawer(
//         child: new ListView(
//           children: <Widget>[
//             new DrawerHeader(
//               child: new Text("DRAWER HEADER..",style : TextStyle(fontWeight: FontWeight.bold)),
//               decoration: new BoxDecoration(
//                   color: Colors.orange[700]
//               ),
//             ),
//             new ListTile(
//               	leading: const Icon(Icons.account_circle),
// 				title: const Text('User Profile'),
//             ),
//             new ListTile(
//               	leading: const Icon(Icons.inbox),
// 				title: const Text('Inbox'),
//             ),
//             new ListTile(
//               	leading: const Icon(Icons.bookmark),
// 				title: const Text('Bookmarks'),
//             ),
//             new ListTile(
//               	leading: const Icon(Icons.calendar_today),
// 				title: const Text('View Calender'),
//             ),
//             new ListTile(
//               	leading: const Icon(Icons.add_to_home_screen),
// 				title: const Text('Post an Ad'),
//             ),
//             new ListTile(
//               	leading: const Icon(Icons.settings),
// 				title: const Text('Settings'),
//             ),
//             new ListTile(
//               	leading: const Icon(Icons.power_settings_new),
// 				title: const Text('Logout'),
//             ),
//             // new ListTile(
//             //   title: new Text("Item => 2"),
//             //   onTap: () {
//             //     Navigator.pop(ctxt);
//             //     Navigator.push(ctxt,
//             //         new MaterialPageRoute(builder: (ctxt) => new SecondPage()));
//             //   },
//             // ),
//           ],
//         )
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatTile extends StatefulWidget{
  final message _msg;

  ChatTile(this._msg);

  @override
  State<StatefulWidget> createState() {
    return ChatTileState(_msg);
  }
}

class ChatTileState extends State<ChatTile>{
  final message _msg;

  ChatTileState(this._msg);

  @override
  Widget build(BuildContext context){
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
        child: Text(_msg.name[0])
      ),
      title: nem,
      subtitle: mesg,
      isThreeLine: true,
      // onTap: ()=>{
      //   _msg.read = _!msg.read;
      // },
    );
  }
}


class MessageList extends StatefulWidget{
  final List<message> allmsgs;

  MessageList(this.allmsgs);
  
  @override
  State<StatefulWidget> createState(){
    return MessageListState(allmsgs);
  }

}


class MessageListState extends State<MessageList>{
  final List<message> allmsgs;

  MessageListState(this.allmsgs);
  @override
  Widget build (BuildContext context){
    return new ListView.separated(
      separatorBuilder : (context,index)=> Divider(
        color : Colors.orange
      ),
      itemCount: allmsgs.length,
      itemBuilder: ((context,index)=>Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: listbuilder(index),
      )),
    );
  }
  ChatTile listbuilder(int i){
    return ChatTile(allmsgs[i]);
  }
}


class InboxPage extends StatefulWidget{

  @override
  InboxPagescreen createState() =>InboxPagescreen(); 
}

class InboxPagescreen extends State<InboxPage>{

	@override
	Widget build (BuildContext ctxt) {
		return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text("Inbox"),
			),
			body: MessageList(listings), 
		);
	}
}


class message {
	const message({this.name,this.latest,this.read, this.date});
	final String name;
	final String latest;
	final bool read;
  final DateTime date;
}

final List<message> listings = <message>[
	message(name: 'Hadi Q' , latest: 'han bhai kya haal hai',read:false, date:DateTime.parse("2019-04-20 19:18:04Z")),
	message(name: 'Ali Ahad' , latest: 'bhai property bechni hai',read:true, date:DateTime.parse("2019-04-20 18:18:04Z")),
	message(name: 'Sheikh' , latest: 'send property',read:true, date:DateTime.parse("2019-04-20 18:48:04Z")),
	message(name: 'Aziz' , latest: 'send property',read:true, date:DateTime.parse("2019-04-20 18:48:04Z")),
	message(name: 'Suleman' , latest: 'send property',read:true, date:DateTime.parse("2019-04-20 18:48:04Z")),
	message(name: 'Ammar' , latest: 'send property',read:true, date:DateTime.parse("2019-04-20 18:48:04Z")),
	message(name: 'GM Ta Ta' , latest: 'send property',read:true, date:DateTime.parse("2019-04-20 18:48:04Z")),
];
class DrawerOnly extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text("DRAWER HEADER..",style : TextStyle(fontWeight: FontWeight.bold)),
              decoration: new BoxDecoration(
                  color: Colors.orange[700]
              ),
            ),
            new ListTile(
              	leading: const Icon(Icons.account_circle),
				title: const Text('User Profile'),
            ),
            new ListTile(
              	leading: const Icon(Icons.inbox),
				title: const Text('Inbox'),
            ),
            new ListTile(
              	leading: const Icon(Icons.bookmark),
				title: const Text('Bookmarks'),
            ),
            new ListTile(
              	leading: const Icon(Icons.calendar_today),
				title: const Text('View Calender'),
            ),
            new ListTile(
              	leading: const Icon(Icons.add_to_home_screen),
				title: const Text('Post an Ad'),
            ),
            new ListTile(
              	leading: const Icon(Icons.settings),
				title: const Text('Settings'),
            ),
            new ListTile(
              	leading: const Icon(Icons.power_settings_new),
				title: const Text('Logout'),
            ),
            // new ListTile(
            //   title: new Text("Item => 2"),
            //   onTap: () {
            //     Navigator.pop(ctxt);
            //     Navigator.push(ctxt,
            //         new MaterialPageRoute(builder: (ctxt) => new SecondPage()));
            //   },
            // ),
          ],
        )
    );
  }
}