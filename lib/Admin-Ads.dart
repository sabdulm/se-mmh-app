import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'property.dart';

int _value =0;
class _AdminAdPageState extends State<AdminAdPage> {
  _AdminAdPageState(this.user);
  final FirebaseUser user;
   final _biggerFont = const TextStyle(
     fontSize: 18.0,
     fontWeight: FontWeight.bold,
   );
  var location =new Location();

  double _currLat= 0;
  double _currLon = 0;
  bool _hasLocation = false;
  @override
  void initState() {
    super.initState();

    getUserLocation();
  }
  void bookmark(){

  }
  void getUserLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
      _currLat = currentLocation["latitude"];
      _currLon = currentLocation["longitude"];
      _hasLocation= true;
    } on Exception {
      currentLocation = null;
    }
  }
  void dropdownWidget(){
    showDialog(
      context: context,
      builder: (_)=>SortDialog(),
    ).then((v){
      if(v){
        setState(() {

        });
      }
    });
  }
  Widget but() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: Colors.white,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Users'),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () => {},
                  textColor: Colors.white,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Ads'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
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
        Route route = new MaterialPageRoute(builder: (context)=> PropertyPage(snapshot.documentID, 'unApprovedProps', user));
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
                  width: screenSize.width-(screenSize.width/2.5) - 60,
                  height: 120,
                  child: Column(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: (screenSize.width-(screenSize.width/2.5) - 60)/2,
                            child: MaterialButton(
                              
                              onPressed: () {_approve(snapshot.documentID);},
                              textColor: Colors.white,
                              color: Colors.orange,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Approve'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (screenSize.width-(screenSize.width/2.5) - 60)/2,
                            child:MaterialButton(
                              onPressed: () {
                                _delete(snapshot.documentID);
                              },
                              textColor: Colors.white,
                              color: Colors.orange,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Delete'),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  void _approve(String snap) async {
    DocumentReference ref = Firestore.instance.collection('unApprovedProps').document(snap);
    DocumentSnapshot snapshot = await ref.get();
    Firestore.instance.collection('Property').add({
      "time" : snapshot['time'],
      "user" : snapshot['user'],
      "name" : snapshot['name'],
      "description" : snapshot['description'],
      "photo" : snapshot['photo'],
      "tags" : snapshot['tags'],
      "location" : snapshot['location'],
      "price" : snapshot['price'],
    }).then((res) =>
        Firestore.instance.runTransaction((transaction) async{
          DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(user.uid));
          await transaction.update(freshsnap.reference,{
            'properties': FieldValue.arrayUnion([res.documentID]),
          });
        }));
    ref.delete();
    Firestore.instance.runTransaction((transaction) async{
      DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(user.uid));
      await transaction.update(freshsnap.reference,{
        'properties': FieldValue.arrayRemove([ref.documentID]),
      });
    });
  }

  void _delete(String snap) async{
    DocumentReference ref = Firestore.instance.collection('unApprovedProps').document(snap);
    Firestore.instance.runTransaction((transaction) async{
      DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(user.uid));
      await transaction.update(freshsnap.reference,{
        'properties': FieldValue.arrayRemove([ref.documentID]),
      });
    });
    ref.delete();
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      drawer: new DrawerOnly(user),
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: (){
              dropdownWidget();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget> [
          but(),
          Flexible(
            child: StreamBuilder(
              stream: streamSelector(_value), //none
              builder: (context, snapshot) {
                Size screenSize = MediaQuery.of(context).size;
                if(!snapshot.hasData) return new Center(
                 child: new CircularProgressIndicator(),
                );
                var temp = snapshot.data.documents;
                if(_hasLocation && _value == 6){
                  temp.sort((a,b){
                    GeoPoint loca1 = a['location'];
                    GeoPoint loca2 = b['location'];
                    var first = sqrt(pow(loca1.latitude-_currLat , 2) + pow(loca1.longitude-_currLon , 2));
                    var second = sqrt(pow(loca2.latitude-_currLat , 2) + pow(loca2.longitude-_currLon , 2));
                    return first.compareTo(second);
                  });
                  return new ListView.builder(
                    padding: EdgeInsets.all(2),
                    itemExtent: 120,
                    itemCount: temp.length,
                    itemBuilder: (context, index)=>_listItemBuilder(context, temp[index], screenSize),
                  );
                }
                return new ListView.builder(
                  padding: EdgeInsets.all(2),
                  itemExtent: 120,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index], screenSize),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class AdminAdPage extends StatefulWidget {
  AdminAdPage(this.user);
  final FirebaseUser user;
  @override
  _AdminAdPageState createState() => new _AdminAdPageState(user);
}


class SortDialog extends StatefulWidget {
  SortDialog({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SortDialogState createState() => new _SortDialogState();
}

class _SortDialogState extends State<SortDialog>{
  int temp = _value;
  @override
  void initState() {
    super.initState();
  }
  void _handler(int num){
    setState(() {
      temp = num;
    });
  }
  @override
  Widget build(BuildContext context){
    final _radioButton = TextStyle(color: Colors.grey);
    return AlertDialog(
      title: new Text('Sort by'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio(
                value: 0,
                onChanged: _handler,
                groupValue: temp,
              ),
              Icon( Icons.not_interested),
              Text('  None', style: _radioButton,),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 1,
                onChanged: _handler,
                groupValue: temp,
              ),
              Icon(Icons.sort_by_alpha),
              Text('  Name', style: _radioButton,),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 2,
                onChanged: _handler,
                groupValue: temp,
              ),
              Icon(Icons.fast_rewind),
              Text('  Earliest First', style: _radioButton,),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 3,
                onChanged: _handler,
                groupValue: temp,
              ),
              Icon(Icons.fast_forward),
              Text('  Latest First', style: _radioButton,),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 4,
                onChanged: _handler,
                groupValue: temp,
              ),
              Icon(Icons.monetization_on),
              Text('  Most Expensive up', style: _radioButton,),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 5,
                onChanged: _handler,
                groupValue: temp,
              ),
              Icon(Icons.money_off),
              Text('  Cheapest up', style: _radioButton,),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 6,
                onChanged: _handler,
                groupValue: temp,
              ),
              Icon(Icons.location_on),
              Text('  Closest to current location', style: _radioButton,),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          child: Text('Close'),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
        new FlatButton(
          color: Colors.orangeAccent,
          child: Text('Done', style: TextStyle(color: Colors.white),),
          onPressed: (){
            _value == temp? Navigator.of(context).pop(false) :Navigator.of(context).pop(true);
            _value = temp;
          },
        )
      ],
    );
  }
}