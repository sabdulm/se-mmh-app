import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';

class PropertyPage extends StatelessWidget {
  PropertyPage(this._key);
  String _key = "";
	String _name = "hello";
	String _address = "Address: " + "LUMS";
	String _description = "Description: UNI Hell";
	String _tags = "Tags: HELL";
	String _price = "Price: 545645132";
  String userID = "DHHl7uVMKgYdiBG0cMD1";


  var imageUrls = <dynamic> [
    'https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg',
    'https://westvancouver.ca/sites/default/files/styles/grid-9/public/coachhouse_0.jpg?itok=G4DGtlrw',
  ];


  List<NetworkImage> _buildNetworkImages(){
    List<NetworkImage> lst = new List<NetworkImage>();
    for (var i = 0; i < imageUrls.length; i++) {
      lst.add(NetworkImage(imageUrls[i]));
    }
    return lst;
  }

	Widget _buildCoverImage(Size screenSize) => new SizedBox(
    height: screenSize.height/3,
    child: imageUrls.length>0? new Carousel(
      boxFit: BoxFit.cover,
      images: _buildNetworkImages(),
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(seconds: 2),
      borderRadius: true,
      indicatorBgPadding: 0.0)
      : 
      Image.asset("no_img.png", fit: BoxFit.cover, ),
  );

  Widget _buildName() => Text(
      _name,
			textAlign: TextAlign.left,
    );

  Widget _buildAddress() => Text(
      _address,
			textAlign: TextAlign.left,
    );

  Widget _buildDescription() => Text(
      _description,
    );

  Widget _buildTags() => Text(
      _tags,
    );

  Widget _buildPrice() => Text(
      _price,
    );

  void getData(DocumentSnapshot snapshot){
    _name = snapshot['name'];
    _tags = snapshot['tags'].join(', ');
    _description = snapshot['description'];
    imageUrls = snapshot['photo'];
    _address = snapshot['location'].toString();
    _price = snapshot['price'].toString();
  }

	@override
	Widget build (BuildContext context) {
		Size screenSize = MediaQuery.of(context).size;
		return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text('Property Details'),
			),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Property').document(_key).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return new Center(
            child: new CircularProgressIndicator(),
          );
          // print(snapshot.data['name']);
          getData(snapshot.data);

          return new ListView(
            padding: EdgeInsets.all(15),
            children: <Widget>[
              _buildName(),
              Divider(),
              _buildCoverImage(screenSize),
              Divider(),
              _buildAddress(),
              Divider(),
              _buildDescription(),
              Divider(),
              _buildTags(),
              Divider(),
              _buildPrice(),
            ],	
          );
        },
      )
		);	
	}
}
