import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'drawer.dart';

class PropertyPage extends StatelessWidget {

	final String _name = "hello";
	final String _address = "Address: " + "LUMS";
	final String _description = "Description: UNI Hell";
	final String _tags = "Tags: HELL";
	final String _price = "Price: 545645132";

  final List<String> imageUrls = <String> [
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
    child: new Carousel(
      boxFit: BoxFit.cover,
      images: _buildNetworkImages(),
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(seconds: 2),
      borderRadius: true,
      indicatorBgPadding: 0.0,
    ),
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

	@override
	Widget build (BuildContext context) {
		Size screenSize = MediaQuery.of(context).size;

		return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text('Property Details'),
			),

      // body: _buildCoverImage(screenSize),

			body: ListView(
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
          // Image.network('https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg'),
          // Image.network(imageUrls[1]),
        ],	
			),
		);	
	}
}
