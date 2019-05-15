
import 'package:flutter/material.dart';
import 'signup2.dart';

class SignUpPage1 extends StatefulWidget {
      SignUpPage1({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _SignUpPage1State createState() => _SignUpPage1State();
    }

class _SignUpPage1State extends State<SignUpPage1> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 23.0, color: Colors.white);
  TextStyle signupstyle = TextStyle(fontFamily: 'Roboto', fontSize: 34.0, color: Color(0xff009aba));
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String emailstr = "", namestr = "";
  String passstr = "", cpassstr = "";
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
    final nameField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        namestr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Name",
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
    final cpasswordField = TextField(
      obscureText: true,
      style: style,
      onChanged: (text) {
        cpassstr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Confirm Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
          
    );
    final signUpRdr = InkWell(
      child: Text('Not a member? Sign up!'),
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
      }
    );
    final nextButon = Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width - 250.0, 0, 0, 0),    
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.orangeAccent[700],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          onPressed: () {
            if(passstr != cpassstr){
              final snackBar = SnackBar(
                content: Text("Error: Both password fields should match"),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change!
                  },
                ),
              );

              // Find the Scaffold in the Widget tree and use it to show a SnackBar!
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }
            else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage2(n: namestr, e: emailstr, p: passstr)),
              );
            }  
          },
          child: Text("Next",
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
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*40.0),
                  Text(
                    "Sign Up",
                    style: signupstyle,
                  ),
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*40.0),
                  nameField,
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*8.0),
                  emailField,
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*8.0),
                  passwordField,
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*8.0),
                  cpasswordField,
                  SizedBox(
                    height: ((MediaQuery.of(context).size.height)/592)*16.0,
                  ),
                  nextButon,
                  SizedBox(
                    height: ((MediaQuery.of(context).size.height)/592)*13.0,
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

