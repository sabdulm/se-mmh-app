import 'package:flutter/material.dart';
import 'listings.dart';

class ResultAdd extends StatelessWidget {
  bool check;
  ResultAdd(this.check);

  Widget _result(){
    if(check){
      return Text('Your Property has been added.');
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
      body: Card(
        child: Center(
          child: Stack(
            children: <Widget>[
              _result(),
              FloatingActionButton(
                heroTag: 'homeBtn',
                child: Icon(Icons.home),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                
              )
            ],
          ),
        )
        
      ),
    );
  }
}