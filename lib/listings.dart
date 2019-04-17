import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'addAd.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async/async.dart';
import 'dart:async';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: Search());
            },
          )
        ],
			),
			body:StreamBuilder( 
				stream: Firestore.instance.collection('Property').snapshots(),
				builder: (context, snapshot){

					Size screenSize = MediaQuery.of(context).size;
					if(!snapshot.hasData) return new Center(
            child: new CircularProgressIndicator(),
          );
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

//Below is the search class
class Search extends SearchDelegate{
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
		return  Card(
			child: Column(
					children: <Widget>[
						ListTile(
							leading: Container(
								child: snapshot['photo'].length<1 ? Container(height: screenSize.height/4, width: screenSize.width/3,) 
											:_image(snapshot['photo'][0], screenSize),
							),
							title: Text(snapshot['name'] ),
							subtitle: Text(snapshot['description'].substring(0,20)),
					 ),
				],
			),
		);	
	}

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }
  
  // // Future<Stream> searchResult(q) async {
  //   List<String> queryKeys = q.split(" "); //the length of this should not be big I should assert but I wont for now TODO to improve latency
  //   CollectionReference firestoreCollection = Firestore.instance.collection("Property");
  //   List<Stream<QuerySnapshot>> streamList = [];

  //   for (int i =0 ; i <queryKeys.length; i++ ){
  //     try{ 
  //       Stream<QuerySnapshot> x = await firestoreCollection.where("name", isEqualTo: queryKeys[i]).snapshots();
  //       streamList.add(x);
  //       Stream<QuerySnapshot> x2 = await  firestoreCollection.where("tags", arrayContains: queryKeys[i]).snapshots();
  //       streamList.add(x2);
  //     } catch(e){
  //     }
  //   }
  //   return StreamZip(streamList).asBroadcastStream();
  //     //this test shows that the stream gets contents from both qury streams
  //     // x.map((convert){ convert.documents.forEach((f){print(f.data["name"]);});}).listen(print); 
    
  // }
  
  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder( 
        stream: Firestore.instance.collection('Property').where("name", isEqualTo: query).snapshots(),
				// stream: searchResult(query),
				builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1){
          return StreamBuilder(
            stream: Firestore.instance.collection('Property').where("tags", arrayContains: query).snapshots(),
            builder: (context, snapshot){
              Size screenSize = MediaQuery.of(context).size;
              if(!snapshot.hasData && !snapshot1.hasData) return new Center(
                child: new CircularProgressIndicator(),
              );
              if(!snapshot.hasData)return new ListView.builder(
                padding: EdgeInsets.all(2),
                itemExtent: screenSize.height/4,
                itemCount: snapshot1.data.documents.length,
                itemBuilder: (context, index)=>_listItemBuilder(context, snapshot1.data.documents[index], screenSize),
              );
              if(!snapshot1.hasData)return new ListView.builder(
                padding: EdgeInsets.all(2),
                itemExtent: screenSize.height/4,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index], screenSize),
              );
              print(snapshot.data.documents.length);
              print(query);
              snapshot.data.documents.addAll(snapshot1.data.documents);
              return new ListView.builder(
                padding: EdgeInsets.all(2),
                itemExtent: screenSize.height/4,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index], screenSize),
              );
            },
          );
					
				}, 
			);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
class MyHomePage extends StatefulWidget {
	@override
	MyState createState() => new MyState();
}
