import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'drawer.dart';

class propertyPage extends StatelessWidget {

	final String _name = "hello";
	final String _address = "Address: " + "LUMS";
	final String _description = "Description: UNI Hell";
	final String _tags = "Tags: HELL";
	final String _price = "Price: 545645132";

  final List<String> image_urls = <String> [
    'https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg',
    'https://westvancouver.ca/sites/default/files/styles/grid-9/public/coachhouse_0.jpg?itok=G4DGtlrw',
  ];

	TextStyle _textStyle = TextStyle(
		color: Colors.black,
		fontSize: 22.0,
		fontWeight: FontWeight.w500,
	);

  List<NetworkImage> _buildNetworkImages(){
    List<NetworkImage> lst = new List<NetworkImage>();
    for (var i = 0; i < image_urls.length; i++) {
      lst.add(NetworkImage(image_urls[i]));
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
      style: _textStyle,
    );

  Widget _buildAddress() => Text(
      _address,
			textAlign: TextAlign.left,
      style: _textStyle,
    );

  Widget _buildDescription() => Text(
      _description,
      style: _textStyle,
    );

  Widget _buildTags() => Text(
      _tags,
      style: _textStyle,
    );

  Widget _buildPrice() => Text(
      _price,
      style: _textStyle,
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
        // padding: EdgeInsets.all(8.0),
        children: <Widget>[
          _buildCoverImage(screenSize),
          _buildName(),
          _buildAddress(),
          _buildDescription(),
          _buildTags(),
          _buildPrice(),
          // Image.network('https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg'),
          // Image.network(image_urls[1]),
        ],	
			),
		);	
	}
}
