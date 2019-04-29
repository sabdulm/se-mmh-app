import 'package:flutter/material.dart';
import 'listings.dart';
import 'package:flutter/services.dart';
import 'drawer.dart';
import 'inbox.dart';

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

      initialRoute: 'home',
      routes: <String, WidgetBuilder>{
        'home': (context) => MyHomePage(),
	'drawer': (context) => Drawer(),
        'inbox' : (context) => InboxPage('Hadi', 'hadi@gmail.com'), //Need name and email here
	'calendar': (context) =>Calendar()
      },
		);
	}
}

