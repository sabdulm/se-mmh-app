import 'package:flutter/material.dart';
import './Admin-Usres.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: AdminUserPage()
    );
  }
}