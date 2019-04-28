import 'package:flutter/material.dart';
import './Profile-Edit.dart';
import './drawer.dart';

void main() => runApp(Profile());

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserProfilePage();
  }
}


class UserProfilePage extends StatelessWidget {

  final String _fullName = "Ammar Tahir";
  final String _email = "at4567@outlook.com";
  Widget _buildUserProfileImage(){
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/profile.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            )
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    return Text(
      _fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildContainer(){

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );


    return Container(
      height:60,
      margin:EdgeInsets.only(top:8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(_email, style: _statCountTextStyle),
            ],),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {},
                textColor: Colors.white,
                color: Colors.orange,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Create Ad'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAds() {
    return Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () {},
          textColor: Colors.white,
          color: Colors.orange,
          padding: const EdgeInsets.all(0.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Text('View Ads'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          RaisedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Edit(),
                )),
            textColor: Colors.white,
            color: Colors.orange,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Text('Edit'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height /20),
                  _buildUserProfileImage(),
                  _buildFullName(),
                  _buildContainer(),
                  _buildAds(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
