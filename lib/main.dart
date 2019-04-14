import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'login.dart';
=======
// import 'listings.dart';

import 'property.dart';

void main() => runApp(MyApp());
>>>>>>> dd88d6c28701a34017d5853c5bd8d8c2ea68049e

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
<<<<<<< HEAD
      // This widget is the root of your application.
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Market My House',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: LoginPage(title: 'Market My House Login'),
        );
      }
    }
=======
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

>>>>>>> dd88d6c28701a34017d5853c5bd8d8c2ea68049e
