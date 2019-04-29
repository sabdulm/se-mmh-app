import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tags/selectable_tags.dart';
import 'drawer.dart';
import 'Profile-Other.dart';
import 'mapProp.dart';

class PropertyPage extends StatelessWidget {
  PropertyPage(this._key, this._col);
  String _key ;
	String _name ;
	String _col;
	var _address;
	String _description ;
	var _tags = [] ;
	String _price ;
  String userID ;
  DocumentReference _user;

  var imageUrls = <dynamic> [];


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
      animationDuration: Duration(seconds: 4),
      borderRadius: true,
      indicatorBgPadding: 0.0)
      : 
      Image.asset("no_img.png", fit: BoxFit.cover, ),
  );

  Widget _buildName() => Text(
      _name,
  );

  Widget _buildDescription() {
    return Text(_description);
  }

  Widget _buildTags() {
    var temp = <Tag> [];
    for (var i = 0; i < _tags.length; i++) {
      temp.add(Tag(title: _tags[i]));
    }

    return SelectableTags(
      tags: temp,
      color: Colors.orangeAccent,
    );
  }

  Widget _buildPrice() {
    return Card(
      child: Text(_price),
      borderOnForeground: true,
    );
  }

  void getData(DocumentSnapshot snapshot){
    _name = snapshot['name'];
    _tags = snapshot['tags'];
    _description = snapshot['description'];
    imageUrls = snapshot['photo'];
    _address = snapshot['location'];
    _price = snapshot['price'].toString();
    _user = snapshot['user'];
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
        stream: Firestore.instance.collection(_col).document(_key).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return new Center(
            child: new CircularProgressIndicator(),
          );
          getData(snapshot.data);

          return new Container(
            child: new SingleChildScrollView(
              child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: screenSize.height/1.2
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    _buildCoverImage(screenSize),
                    Divider(),
                    _buildName(),
                    Divider(),
                    _buildDescription(),
                    Divider(),
                    _buildTags(),
                    Divider(),
                    _buildPrice(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => PropertyMap(_address, _name)),
                            );

                          },
                          icon: Icon(Icons.map),
                          label: Text('View in Map'),
                          color: Colors.orangeAccent,
                        ),
                        FlatButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Profile(_user.documentID)),
                            );
                          },
                          icon: Icon(Icons.person),
                          label: Text('View User'),
                          color: Colors.orangeAccent,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      )
		);	
	}
}
