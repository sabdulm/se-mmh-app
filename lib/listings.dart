import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'search.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'property.dart';
import 'addAd.dart';
int _value =0;
class MyState extends State<MyHomePage> {
	final Set<String> _saved = new Set<String>(); 
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
	Widget _image (String url, Size screenSize){
			if(url == ''){
        return new SizedBox(
          height: 120,
          width: screenSize.width/2.5,
          child: ClipRect(child:new Container(child:new Image.asset("no_img.jpg", fit: BoxFit.fill,)),)
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
		final bool alreadySaved = _saved.contains(snapshot.documentID);
		// print("List item: ${snapshot.documentID}");
    // print(snapshot.data);
    return new GestureDetector(
      onTap: (){
            Route route = new MaterialPageRoute(builder: (context)=> PropertyPage(snapshot.documentID, 'Property'));
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
                new Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  child: new IconButton(
                    icon: alreadySaved? new Icon(Icons.bookmark) : new Icon(Icons.bookmark_border),
                    color: alreadySaved? Colors.orangeAccent : null,  
                    onPressed: () {
                      setState(() {
                          if (alreadySaved) {
                            _saved.remove(snapshot.documentID);
                          } else { 
                            _saved.add(snapshot.documentID);
                            
                          }
                        });
                      },
                    ),
                ),
              ],
            ),
            new Divider(),
          ],
        )
      ),
    ); 
  }
  Stream<QuerySnapshot> streamSelector(int num){
    switch (num) {
      case 1: return Firestore.instance.collection('Property').orderBy('name').snapshots();
      case 2: return Firestore.instance.collection('Property').orderBy('time', descending: false).snapshots();
      case 3: return Firestore.instance.collection('Property').orderBy('time', descending: true).snapshots();// lates
      case 4: return Firestore.instance.collection('Property').orderBy('price', descending: true).snapshots();// expensive
      case 5: return Firestore.instance.collection('Property').orderBy('price', descending: false).snapshots();
      default: return Firestore.instance.collection('Property').snapshots();
    }
  }
	@override
	Widget build (BuildContext context) {
		// print("listings: ${_value}");
    return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text("Drawer Demo"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: Search());
            },
          ),
          new IconButton(
            icon: new Icon(Icons.filter_list),
            onPressed: (){
              dropdownWidget();            
            },
          ),
        ],
			),
			body: new StreamBuilder( 
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
                itemExtent: 140,
                itemCount: temp.length,
                itemBuilder: (context, index)=>_listItemBuilder(context, temp[index], screenSize),
              );
            }
            return new ListView.builder(
              padding: EdgeInsets.all(2),
              itemExtent: 140,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index], screenSize),
            );
          }, 
        ), //<-------add lists here!!!
      floatingActionButton: new FloatingActionButton(
				child: new Icon(Icons.photo_filter), 
				onPressed: () {
					// Route route = MaterialPageRoute(builder: (context)=> AddAd());
					Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => AddAd(),
            ),
          );
				},
			),
		);
	}
}
class MyHomePage extends StatefulWidget {
	@override
	MyState createState() => new MyState();
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
    final _radioButton = new TextStyle(color: Colors.grey);
    return new AlertDialog(
      title: new Text('Sort by'),
        content: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Radio(
                  value: 0,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                new Icon( Icons.not_interested),
                new Text('  None', style: _radioButton,),
              ],
            ),
            new Row(
              children: <Widget>[
                new Radio(
                  value: 1,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                new Icon(Icons.sort_by_alpha),
                new Text('  Name', style: _radioButton,),
              ],
            ),
            new Row(
              children: <Widget>[
                new Radio(
                  value: 2,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                new Icon(Icons.fast_rewind),
                new Text('  Earliest', style: _radioButton,),
              ],
            ),
            new Row(
              children: <Widget>[
                new Radio(
                  value: 3,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                new Icon(Icons.fast_forward),
                new Text('  Latest', style: _radioButton,),
              ],
            ),
            new Row(
              children: <Widget>[
                new Radio(
                  value: 4,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                new Icon(Icons.monetization_on),
                new Text('  Price up', style: _radioButton,),
              ],
            ),
            new Row(
              children: <Widget>[
                new Radio(
                  value: 5,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                new Icon(Icons.money_off),
                new Text('  Price down', style: _radioButton,),
              ],
            ),
            new Row(
              children: <Widget>[
                new Radio(
                  value: 6,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                new Icon(Icons.location_on),
                new Text('  Location', style: _radioButton,),
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
            child: new Text('Done', style: TextStyle(color: Colors.white),),
            onPressed: (){
              _value == temp? Navigator.of(context).pop(false) :Navigator.of(context).pop(true);
              _value = temp;
            },
          )
        ],
    );
  }
}