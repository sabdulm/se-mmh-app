import 'package:flutter/material.dart';
import 'dart:async';
import 'signup3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SignUpPage2 extends StatefulWidget {
      const SignUpPage2({Key key, this.n, this.e, this.p}) : super(key: key);
      final String n, e, p;
      @override
      _SignUpPage2State createState() => _SignUpPage2State(n: n, e: e, p: p);
    }

class _SignUpPage2State extends State<SignUpPage2> {
  _SignUpPage2State({Key key, this.n, this.e, this.p});
  String n, e, p;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 23.0, color: Colors.white);
  TextStyle signupstyle = TextStyle(fontFamily: 'Roboto', fontSize: 34.0, color: Color(0xff009aba));
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String titlestr = "", addrstr = "";
  String mobilestr = "", cpassstr = "";
  DateTime dob = DateTime.now();
  String dobstr = "";

 
  Future<void> register() async{
    print("Preparing to register.");
    try{
      // DocumentReference ref = Firestore.instance.collection("Property").document("whRWznBFcTX9fTx6ySpY");
      DocumentReference ref = null;
      var prop = [ref];
      var chat = [ref];
      var bookmark = [ref];

      FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: e.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), ""), password: p);
      print("Signed up.");
      user.sendEmailVerification();
      print(user.uid);
      Firestore.instance.collection('users').add({
        "title" : titlestr,
        "user" : user.uid,
        "email" : e.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), ""),
        "name" : n,
        "address" : addrstr,
        "phoneNumber" : mobilestr,
        "dateOfBirth" : dob,
        "createdOn" : DateTime.now(),
        "isAdmin" : false,
        "properties": prop,
        "inbox" : chat,
        "bookmarks" : bookmark,
        "photo" : "https://firebasestorage.googleapis.com/v0/b/mmhapp-576cd.appspot.com/o/person-placeholder.png?alt=media&token=6f309a54-b83b-4074-b27b-b5366b7796bf",

      });
                      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage3()),
      );
    }catch(re){
      final snackBar = SnackBar(
        content: Text(re.message),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change!
          },
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

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
            
            register();
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
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*40.0),
                  Text(
                    "Sign Up",
                    style: signupstyle,
                  ),
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*40.0),
                  addrField,
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*8.0),
                  titleField,
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*8.0),
                  passwordField,
                  SizedBox(height: ((MediaQuery.of(context).size.height)/592)*8.0),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date of Birth'),
                  ),
                  SizedBox(
                    height: ((MediaQuery.of(context).size.height)/592)*18.0,
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
