import 'dart:async';

import 'package:flutter/material.dart';
import 'signup1.dart';
import 'listings.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle style2 = TextStyle(fontFamily: 'Roboto', fontSize: 16.5, color: Colors.black);
  TextStyle style3 = TextStyle(fontFamily: 'Roboto', fontSize: 15.5, color: Colors.red);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 23.0, color: Colors.white);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String emailstr = "";
  String passstr = "";
  String errtext = "";
  bool overlay = false;

  bool auth(){
    return true;
  }

  Text renameErr(String errmessage){
    String message = "";
    if(errmessage.contains("invalid")){
      message = "The password is invalid.";
    }
    else if(errmessage.contains("identifier")){
      message = "This email address is not registered with any account.";
    }
    else if(errmessage.contains("empty")){
      message = "The email or password field can not be empty.";
    }
    else{
      print("...");
      message = errmessage;
    }
    return Text(message);
  }

  Future<void> signIn() async{
    if(auth()){
      print("Preparing to log in.");
      setState(() {overlay = true;});
       _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 2), content:
          new Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              new Text("  Signing in, please wait..."),
            ],
          ),
        )
      );
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailstr.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), ""), password: passstr);
        print("Signed in.");
        Navigator.pushNamed(
          context,
          MyHomePage.routeName,
          arguments: user,
        );
      }catch(e){
        final snackBar = SnackBar(
          content: renameErr(e.message),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change!
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    setState(() {overlay = false;});
    }
  }

  @override
  void initState() {
    super.initState();
    overlay = false;
  }
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
    var errorfield = InkWell(
      child: Text(errtext, style: style3,),
    );

 
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orangeAccent[700],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        onPressed: () {
          // final snackBar = SnackBar(
          //   content: Text("Email entered: " + emailstr + ", Pass entered: " + passstr),
          //   action: SnackBarAction(
          //     label: 'Undo',
          //     onPressed: () {
          //       // Some code to undo the change!
          //     },
          //   ),
          // );

          // // Find the Scaffold in the Widget tree and use it to show a SnackBar!
          // _scaffoldKey.currentState.showSnackBar(snackBar);
          setState((){errtext = "hooooo";});
          signIn();
          errorfield = InkWell(
            child: Text(errtext, style: style3,),
          );
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
            content: Text((MediaQuery.of(context).size.height).toStringAsFixed(2)),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change!
              },
            ),
            
          );
          Navigator.pushNamed(
            context,
            MyHomePage.routeName,
            arguments: null,
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


    Stack mainbody(){
      // checklogin();
      if(true ){
        return Stack(
          children: <Widget>[
            Center(
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
                        SizedBox(height: ((MediaQuery.of(context).size.height)/592)*20.0),
                        SizedBox(
                          height: ((MediaQuery.of(context).size.height)/592)*150.0,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: ((MediaQuery.of(context).size.height)/592)*40.0),
                        emailField,
                        SizedBox(height: ((MediaQuery.of(context).size.height)/592)*7.0),
                        passwordField,
                        SizedBox(
                          height: ((MediaQuery.of(context).size.height)/592)*30.0,
                        ),
                        // errorfield,
                        // SizedBox(
                        //   height: ((MediaQuery.of(context).size.height)/592)*20.0,
                        // ),
                        loginButon,
                        SizedBox(
                          height: ((MediaQuery.of(context).size.height)/592)*10.0,
                        ),
                        guestButon,
                        SizedBox(
                          height: ((MediaQuery.of(context).size.height)/592)*40.0,
                        ),
                        signUpRdr,
                        SizedBox(
                          height: ((MediaQuery.of(context).size.height)/592)*30.0,
                        ),
                        
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
          ],
        );
      }
      else{
        return Stack(
          children: <Widget>[
            SizedBox(
              height: ((MediaQuery.of(context).size.height)/592)*150.0,
              child: Image.asset(
                "assets/load.gif",
                fit: BoxFit.contain,
              ),
            ),
          ],
        );
      }
    }

    // checklogin();
    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomPadding: false,
      body: mainbody(),
    );
  }
}
