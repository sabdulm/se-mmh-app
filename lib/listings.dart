import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'search.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'property.dart';
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
        return SizedBox(
          height: screenSize.height/5.5,
				  width: screenSize.width/2,
          child: Image.asset("no_img.png", fit: BoxFit.fill,)
        );
      }
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
		print("List item: ${snapshot.documentID}");
    return  Card(
			child: Column(
					children: <Widget>[
						ListTile(
							leading: Container(
								child: snapshot['photo'].length<1 || snapshot['photo']==null ? _image('',screenSize) 
											:_image(snapshot['photo'][0], screenSize),
							),
							title: Text(snapshot['name'] , style: _biggerFont,),
							subtitle: Text(snapshot['description'].substring(0,20)),
							trailing: IconButton(
								icon: alreadySaved? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
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
							onTap: (){
                Route route = MaterialPageRoute(builder: (context)=> PropertyPage(snapshot.documentID));
                Navigator.of(context).push(route);
 
              },
					 ),
				],
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
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: Search());
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: (){
              dropdownWidget();            
            },
          ),
        ],
			),
			body: StreamBuilder( 
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
                itemExtent: screenSize.height/4,
                itemCount: temp.length,
                itemBuilder: (context, index)=>_listItemBuilder(context, temp[index], screenSize),
              );
            }
            return new ListView.builder(
              padding: EdgeInsets.all(2),
              itemExtent: screenSize.height/4,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index], screenSize),
            );
          }, 
        ), //<-------add lists here!!!
      floatingActionButton: FloatingActionButton(
				child: Icon(Icons.photo_filter), 
				onPressed: () {
					// Route route = MaterialPageRoute(builder: (context)=> AddAd());
					Navigator.pushNamed(context, '/addAd');
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