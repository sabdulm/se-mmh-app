import 'package:flutter/material.dart';
import 'dart:async';
import 'signup3.dart';


class SignUpPage2 extends StatefulWidget {
      SignUpPage2({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _SignUpPage2State createState() => _SignUpPage2State();
    }

class _SignUpPage2State extends State<SignUpPage2> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 23.0, color: Colors.white);
  TextStyle signupstyle = TextStyle(fontFamily: 'Roboto', fontSize: 34.0, color: Color(0xff009aba));
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String titlestr = "", addrstr = "";
  String mobilestr = "", cpassstr = "";
  DateTime dob = DateTime.now();
  String dobstr = "";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now());
      if (picked != null && picked != DateTime.now())
      setState(() {
        dob = picked;
        String dateSlug ="${dob.year.toString()}-${dob.month.toString().padLeft(2,'0')}-${dob.day.toString().padLeft(2,'0')}";
        dobstr = dateSlug;
      });
  }

  @override
  Widget build(BuildContext context) {

    final titleField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        titlestr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Title",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final addrField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        addrstr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Address",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final passwordField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        mobilestr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Phone Number",
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
            final snackBar = SnackBar(
              content: Text("Addr entered: " + addrstr + ", Title entered: " + titlestr + ", Phone entered: " + mobilestr + ", DoB: " + dobstr),
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
            MaterialPageRoute(builder: (context) => SignUpPage3()),
            ); 
          },
          child: Text("Sign Up",
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
                  SizedBox(height: 50.0),
                  Text(
                    "Sign Up",
                    style: signupstyle,
                  ),
                  SizedBox(height: 50.0),
                  addrField,
                  SizedBox(height: 10.0),
                  titleField,
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(height: 10.0),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date of Birth'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  nextButon,
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
