import 'package:flutter/material.dart';
import 'signup1.dart';

class LoginPage extends StatefulWidget {
      LoginPage({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _LoginPageState createState() => _LoginPageState();
    }

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle style2 = TextStyle(fontFamily: 'Roboto', fontSize: 16.5, color: Colors.black);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 23.0, color: Colors.white);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String emailstr = "";
  String passstr = "";
  // var snacktxt = "Email entered: " + emailstr + ", Pass entered: " + passstr; 
  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        emailstr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      onChanged: (text) {
        passstr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
          
    );
    final signUpRdr = InkWell(
      child: Text('Not a member? Tap here to sign up!', style: style2,),
      onTap: () {
        final snackBar = SnackBar(
            content: Text("Redirect to the sign up page."),
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
            MaterialPageRoute(builder: (context) => SignUpPage1()),
          );
      }
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orangeAccent[700],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        onPressed: () {
          final snackBar = SnackBar(
            content: Text("Email entered: " + emailstr + ", Pass entered: " + passstr),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change!
              },
            ),
          );

          // Find the Scaffold in the Widget tree and use it to show a SnackBar!
          _scaffoldKey.currentState.showSnackBar(snackBar);
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: butt.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final guestButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xff009aba),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        onPressed: () {
          final snackBar = SnackBar(
            content: Text("Logging in as a guest."),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change!
              },
            ),
          );

          // Find the Scaffold in the Widget tree and use it to show a SnackBar!
          _scaffoldKey.currentState.showSnackBar(snackBar);
        },
        child: Text("Login as a guest",
            textAlign: TextAlign.center,
            style: butt.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
                  SizedBox(height: 30.0),
                  SizedBox(
                    height: 185.0,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  emailField,
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(
                    height: 20.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 15.0,
                  ),
                  guestButon,
                  SizedBox(
                    height: 50.0,
                  ),
                  signUpRdr,
                  SizedBox(
                    height: 40.0,
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
