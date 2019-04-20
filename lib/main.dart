import 'package:flutter/material.dart';
import 'listings.dart';
import 'package:flutter/services.dart';
import 'maps.dart';
import 'property.dart';
import 'addAd.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
			title: 'Listings:',
			theme: ThemeData(
				primarySwatch: Colors.orange,
			),
			home: new MyHomePage(),

      initialRoute: '',
      routes: {
        'home': (context) => MyHomePage(),
        'addAd': (context) => AddAd(),
        'maps': (context) => MyMap(),
      },
		);
	}
}

