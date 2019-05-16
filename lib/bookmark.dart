import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'property.dart';

class _Bookmarks extends State<Bookmarks> {
  _Bookmarks(this.user);
  final _biggerFont = const TextStyle(
															fontSize: 18.0,
															fontWeight: FontWeight.bold,
														);
  
  final Set<DocumentReference> _saved = new Set<DocumentReference>(); 
  final FirebaseUser user;
  @override
  void initState() {
    super.initState();
    getUser();
  }
  void getUser(){
    Stream<QuerySnapshot> user =   Firestore.instance.collection('users').where('user', isEqualTo: this.user.uid).snapshots();
    user.listen((data) {
      if(data!=null){
        setState(() {
          data.documents[0]['bookmarks'].forEach((x) => _saved.add(x));
        });
      }
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print("Some Error");
    });
    // print("${user.data.documents[0]['name']} <--here it is");
  }
  Widget _image (String url, Size screenSize){
    if(url == ''){
        return new SizedBox(
          height: 120,
          width: screenSize.width/2.5,
          child: ClipRect(child:new Container(child:new Image.asset("no_img.png", fit: BoxFit.fill,)),)
        );
      }
      return new SizedBox(
        height: 120,
				width: screenSize.width/2.5,
				child: new ClipRect(
          child: new Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: new DecorationImage(
                image: new NetworkImage(url),
                fit: BoxFit.fill,
              ),
            ),
          ),
			  ),
      );
  }
  Widget _listItemBuilder (BuildContext context , DocumentSnapshot snapshot, Size screenSize){
    return new GestureDetector(
      onTap: (){
        Route route = new MaterialPageRoute(builder: (context)=> PropertyPage(snapshot.documentID, 'Property', user));
        Navigator.of(context).push(route);
      },
      child: new Container(
          padding: EdgeInsets.only(left: 5, right: 5,),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  snapshot['photo'].length<1 || snapshot['photo']==null ? _image('',screenSize) :_image(snapshot['photo'][0], screenSize),
                  new VerticalDivider(color: Colors.black,width: 16,),
                  new Container(
                   width: screenSize.width-(screenSize.width/2.5) - 80,
                   height: 120,
                   child: new Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       new Text("${snapshot['name'][0].toUpperCase()}${snapshot['name'].substring(1).toLowerCase()}",overflow: TextOverflow.ellipsis ,maxLines: 1, style: _biggerFont,),
                       new Text(
                         snapshot['description'],
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(color: Colors.grey),
                         maxLines: 2,
                       ),
                       Spacer(),
                       Container(
                         child:new Text("£${snapshot['price']}.00",style: TextStyle(color: Colors.black87),),
                         alignment: Alignment.bottomRight,
                       ),
                       // snapshot['description'].length>20? new Text("${snapshot['description'].substring(0,20)}..."): new Text(snapshot['description']),
                     ],
                   ),
                 ),
               ],
              ),
            ],
          )
      ),
    );
  }

  Stream<QuerySnapshot> streamSelector(int num){
    switch (num) {
      case 1: return Firestore.instance.collection('unApprovedProps').orderBy('name').snapshots();
      case 2: return Firestore.instance.collection('unApprovedProps').orderBy('time', descending: false).snapshots();
      case 3: return Firestore.instance.collection('unApprovedProps').orderBy('time', descending: true).snapshots();// lates
      case 4: return Firestore.instance.collection('unApprovedProps').orderBy('price', descending: true).snapshots();// expensive
      case 5: return Firestore.instance.collection('unApprovedProps').orderBy('price', descending: false).snapshots();
      default: return Firestore.instance.collection('unApprovedProps').snapshots();
    }
  }
  @override
  Widget build (BuildContext context) {
    // print("listings: ${_value}");
    return new Scaffold(
      drawer: new DrawerOnly(user),
      appBar: new AppBar(
        title: new Text("Bookmarks"),
      ),
      body:StreamBuilder(
            stream: Firestore.instance.collection('Property').snapshots(), //none
            builder: (context, snapshot) {
              Size screenSize = MediaQuery.of(context).size;
              if(!snapshot.hasData || _saved.isEmpty || user==null) return new Center(
               child: new CircularProgressIndicator(),
              );
              var list =[];
              for (var item in snapshot.data.documents) {
                if(_saved.contains(item.reference)) list.add(item);
              }
              return new ListView.builder(
                padding: EdgeInsets.all(2),
                itemExtent: 140,
                itemCount: list.length,
                itemBuilder: (context, index)=>_listItemBuilder(context, list[index], screenSize),
              );
            },
          ),
    );   //<-------add lists here!!!
  }
}
class Bookmarks extends StatefulWidget {
  Bookmarks(this.user);
  final FirebaseUser user;
  @override
  _Bookmarks createState() => new _Bookmarks(user);
}

//Routing class below
class MyBookmarkPage extends StatelessWidget {
  static const routeName = 'bookmark';
  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = ModalRoute.of(context).settings.arguments;
    return Bookmarks(user);
  }
}