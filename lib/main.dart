import 'package:flutter/material.dart';
import 'login.dart';
import 'listings.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
      // This widget is the root of your application.
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Market My House',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                return MyHomePage();
              }
              else {
                return LoginPage(title: 'Market My House Login');
              }
            }
          )
        );
      }
    }