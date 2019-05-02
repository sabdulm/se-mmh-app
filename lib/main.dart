import 'package:flutter/material.dart';
import 'login.dart';
import 'listings.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
      // This widget is the root of your application.
      bool login = false;
      FirebaseUser usercheck;

      void checklogin() async{
        FirebaseUser usercheck = await FirebaseAuth.instance.currentUser();
        if (usercheck != null){       
          login = true;
        }
      }

      @override
      Widget build(BuildContext context) {
        checklogin();
        if(login == "false"){
          return MaterialApp(
            title: 'Market My House',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: LoginPage(title: 'Market My House Login'),
          );
        }
        else{
          return MaterialApp(
            title: 'Market My House',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            // home: MyHomePage(user: usercheck),
            home: LoginPage(title: 'Market My House Login'),

          );
        }
      }
    }