import 'package:flutter/material.dart';
import 'login.dart';
import 'listings.dart';
import 'calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'bookmark.dart';
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
          title: 'Market My House',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          initialRoute: '/',
          routes: {
            MyHomePage.routeName : (context) => MyHomePage(),
            MyBookmarkPage.routeName : (context) => MyBookmarkPage(),
            'calender' : (context) => Calendar(),
          },
          home: FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            //  if (snapshot.hasData) {
            //   //  FirebaseUser user = snapshot.data;
            //    return MyHomePage();
            //  }
            //  else {
                return LoginPage(title: 'Market My House Login');
            //  }
            }
          )
        );
      }
    }