import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';
import 'addAd.dart';
import 'search.dart';
import 'package:location/location.dart';
import 'dart:math';

int _value = 0;
	
class MyState extends State<MyHomePage> {
	final Set<String> _saved = new Set<String>(); 
	final _biggerFont = const TextStyle(
															fontSize: 18.0,
															fontWeight: FontWeight.bold,
														);
  var location =new Location();
  double curr_lat= 0;
  double curr_lon = 0;
  bool has_location = false;
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
      curr_lat = currentLocation["latitude"];
      curr_lon = currentLocation["longitude"];
      has_location= true;
      print("$curr_lat - $curr_lon");
    } on Exception {
      currentLocation = null;
    }
  }
	void dropdownWidget(){
    showDialog(
      context: context,
      builder: (_)=>SortDialog(),
    );
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
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: (){
              dropdownWidget();            
            },
          ),
          
        ],
			),
			body:StreamBuilder( 
				stream: _value == 2?Firestore.instance.collection('Property').orderBy('time', descending: false).snapshots() //earliest -2
                            : _value ==1? Firestore.instance.collection('Property').orderBy('name').snapshots() //1 = name
                            :_value ==3? Firestore.instance.collection('Property').orderBy('time', descending: true).snapshots()// lates
                            :_value ==4? Firestore.instance.collection('Property').orderBy('price', descending: true).snapshots()// expensive
                            :_value ==5? Firestore.instance.collection('Property').orderBy('price', descending: false).snapshots()// cheapest
                            :Firestore.instance.collection('Property').snapshots(), //none                   
				builder: (context, snapshot) {
          Size screenSize = MediaQuery.of(context).size;
					if(!snapshot.hasData) return new Center(
            child: new CircularProgressIndicator(),
          );
          var temp = snapshot.data.documents;
          if(has_location){
            GeoPoint loca = temp[0]['location'];
            print("location: ${temp[0]['location']} , ${loca.latitude} , ${loca.longitude}");
            temp.sort((a,b){
              GeoPoint loca1 = a['location'];
              GeoPoint loca2 = b['location'];
               
              var first = sqrt(pow(loca1.latitude-curr_lat , 2) + pow(loca1.longitude-curr_lon , 2));
              var second = sqrt(pow(loca2.latitude-curr_lat , 2) + pow(loca2.longitude-curr_lon , 2));
              return first.compareTo(second);
            });
          }
          return new ListView.builder(
						padding: EdgeInsets.all(2),
						itemExtent: screenSize.height/4,
						itemCount: temp.length,
						itemBuilder: (context, index)=>_listItemBuilder(context, temp[index], screenSize),
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
      temp = _value;
	}
  void _handler(int num){
    setState(() {
      temp = num;  
    });
  }
  @override
  Widget build(BuildContext context){
    
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
                Text('None'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 1,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                Text('Name'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 2,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                Text('Earliest First'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 3,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                Text('Latest First'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 4,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                Text('Most Expensive up'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 5,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                Text('Cheapest up'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 6,
                  onChanged: _handler,
                  groupValue: temp,
                ),
                Text('Closest to current location'),
              ],
            ),
              
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            child: Text('Close'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            color: Colors.orangeAccent,
            child: Text('Done', style: TextStyle(color: Colors.white),),
            onPressed: (){
              if(temp==_value){
                Navigator.of(context).pop();
              }
              _value= temp;
              Route route = MaterialPageRoute(builder: (context)=> MyHomePage());
              Navigator.of(context).push(route);
            },
          )
        ],
    );
  }
}