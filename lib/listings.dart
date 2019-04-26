import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'addAd.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyState extends State<MyHomePage> {

  final Set<String> _saved = new Set<String>(); 
  final _biggerFont = const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            );
  
  @override
  void initState() {
      super.initState();
  }
  void bookmark(){

  }
  
  Widget _image (String url){
      return Container( 
        // padding: EdgeInsets.only(top: 50),
        child: ClipRRect(
        borderRadius: new BorderRadius.circular(20.0),
        child: Image.network(
            url,
            height: 110.0,
            width: 160.0,
        ),
      ),
    );
  }
  Widget _listItemBuilder (BuildContext context , DocumentSnapshot snapshot){
		final bool alreadySaved = _saved.contains(snapshot.documentID);
    return  Card(
      child: Column(
          children: <Widget>[
            ListTile(
              leading: snapshot['photo'].length<1 ? Container(height: 110.0, width: 160.0,) 
                                          :_image(snapshot['photo'][0]),
              title: Text(snapshot['name'] , style: _biggerFont,),
              subtitle: Text(snapshot['description']),
              trailing: Icon(
                alreadySaved? Icons.bookmark : Icons.bookmark_border,
                color: alreadySaved? Colors.orangeAccent : null,  
                ),
              onTap: () {
              setState(() {
                  if (alreadySaved) {
                    _saved.remove(snapshot.documentID);
                  } else { 
                    _saved.add(snapshot.documentID);
                     
                  }
                });
              },
           ),
        ],
      ),
    );		// return Text(listings[index].name);
	}

	@override
	Widget build (BuildContext ctxt) {
		return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text("${(widget.user.uid).toString()}"),
			),
			body:
      StreamBuilder( 
        stream: Firestore.instance.collection('Property').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return const Text('Loading...');
          return new ListView.builder(
            itemExtent: 140.0,
            // padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index]),
          );
        }, 
      ), //<-------add lists here!!!
			floatingActionButton: FloatingActionButton(
				tooltip: 'Increment',
				child: Icon(Icons.photo_filter), 
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context)=> AddAd());
          Navigator.push(context, route);
        },
			),
      
		);
	}
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  MyState createState() => new MyState();
}
