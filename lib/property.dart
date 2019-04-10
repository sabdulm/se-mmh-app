import 'package:flutter/material.dart';
import 'drawer.dart';

class propertyPage extends StatelessWidget {

	// String get getName => "LUMS";

	final String _name = "hello";
	final String _address = "Address: " + "LUMS";
	final String _description = "Description: UNI Hell";
	final String _tags = "Tags: HELL";
	final String _price = "Price: 545645132";


	TextStyle _textStyle = TextStyle(
		color: Colors.black,
		fontSize: 22.0,
		fontWeight: FontWeight.w500,
	);

	Widget _buildCoverImage(Size screenSize) => Container(
			height: screenSize.height / 3,
			decoration: BoxDecoration(
				image: DecorationImage(
					image: NetworkImage	('https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg'),
					fit: BoxFit.cover,
				),
			),
		);

  Widget _buildName() => Text(
      _name,
      style: _textStyle,
    );

  Widget _buildAddress() => Text(
      _address,
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
			body: Stack(
				children: <Widget>[
					SafeArea(
						child: SingleChildScrollView(
							child: Column(
								children: <Widget>[
									_buildName(),
									_buildCoverImage(screenSize),
									_buildAddress(),
									_buildDescription(),
									_buildTags(),
									_buildPrice(),
								],
							),
						),
					)
				],	
			),
		);	
	}
}
