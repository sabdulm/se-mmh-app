import 'package:flutter/material.dart';
// import 'dart:async';
import 'login.dart';


class SignUpPage3 extends StatefulWidget {
      SignUpPage3({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _MyHomePageState createState() => _MyHomePageState();
    }

class _MyHomePageState extends State<SignUpPage3> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 23.0, color: Colors.white);
  TextStyle signupstyle = TextStyle(fontFamily: 'Roboto', fontSize: 34.0, color: Color(0xff009aba));
   final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final backButon = Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width - 250.0, 0, 0, 0),    
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.orangeAccent[700],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          onPressed: () {
            final snackBar = SnackBar(
              content: Text("Redirected to login"),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change!
                },
              ),
            );

            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
            _scaffoldKey.currentState.showSnackBar(snackBar);
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            ); 
          },
          child: Text("Back",
              textAlign: TextAlign.center,
              style: butt.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomPadding: false,
      body: Center(

        child: ListView(
          children: <Widget> [
            Container(
            color: Colors.white30,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 250.0),
                  Text(
                    "A confirmation email has been sent to you. Please confirm your account within 24 hours or the link in the email will expire.",
                    style: style,
                  ),
                  SizedBox(height: 30.0),
                  
                  backButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

