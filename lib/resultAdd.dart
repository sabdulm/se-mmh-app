import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'listings.dart';
class ResultAdd extends StatelessWidget {
  final bool check;
  FirebaseUser user;
  ResultAdd(this.check, this.user);

  Widget _result(){
    if(check){
      return Text('Your Property has been added for approval.');
    } else{
      return Text('An error occured, Please try again');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Add Property'),
      ),
      body: Align(
        alignment: Alignment.center,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _result(),
              FlatButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    MyHomePage.routeName,
                    arguments: user,
                  );
                  // Navigator.popUntil(context, ModalRoute.withName('listings'));
                }, 
                icon: Icon(Icons.home),
                label: Text('Return to home'),
                color: Colors.orangeAccent,
                
              )
            ],
          ),
      ),
    );
  }
}