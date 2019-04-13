import 'package:flutter/material.dart';
import 'listings.dart';

import 'property.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Listings:',
			theme: ThemeData(
				primarySwatch: Colors.orange,
			),
			home: new PropertyPage(),
		);
	}
}

