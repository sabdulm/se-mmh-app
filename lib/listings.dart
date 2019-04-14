import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'addAd.dart';

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
	
	Widget _image (String url, Size screenSize){
			return new SizedBox(
				height: screenSize.height/5.5,
				width: screenSize.width/2,
				child: Container(
					decoration: BoxDecoration(
						image: DecorationImage(
							image: NetworkImage(url),
							fit: BoxFit.fill,
						),
					),
				),
			);
	}
	Widget _listItemBuilder (BuildContext context , DocumentSnapshot snapshot, Size screenSize){
		final bool alreadySaved = _saved.contains(snapshot.documentID);
		return  Card(
			child: Column(
					children: <Widget>[
						ListTile(
							leading: Container(
								child: snapshot['photo'].length<1 ? Container(height: screenSize.height/4, width: screenSize.width/3,) 
											:_image(snapshot['photo'][0], screenSize),
							),
							title: Text(snapshot['name'] , style: _biggerFont,),
							subtitle: Text(snapshot['description'].substring(0,20)),
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
		);	
	}

	@override
	Widget build (BuildContext context) {
		return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text("Drawer Demo"),
			),
			body:StreamBuilder( 
				stream: Firestore.instance.collection('Property').snapshots(),
				builder: (context, snapshot){

					Size screenSize = MediaQuery.of(context).size;
					if(!snapshot.hasData) return const Text('Loading...');
					return new ListView.builder(
						padding: EdgeInsets.all(2),
						itemExtent: screenSize.height/4,
						itemCount: snapshot.data.documents.length,
						itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index], screenSize),
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
	@override
	MyState createState() => new MyState();
}
