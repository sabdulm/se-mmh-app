import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './drawer.dart';

var _docId = '';

class Profile extends StatefulWidget {
  String id;
  Profile(this.id);
  @override
  ProfileState createState() {
    _docId = id;
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Profile',
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home : UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  Widget _buildUserProfileImage(DocumentSnapshot snap){
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(snap['photo']),
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

  Widget _buildFullName(DocumentSnapshot snap) {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    if (snap['name'] != null){
      return new Text(
        snap['name'],
        style: _nameTextStyle,
      );
    }
    return new Text('loading');

  }

  Widget _buildContainer(DocumentSnapshot snap){
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
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  textColor: Colors.white,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Message'),
                  ),
                ),
              ],
            ),
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
                    child: Text('Appointments'),
                  ),
                ),
              ],
            ),
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
                    child: Text('Block'),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget _buildAds(DocumentSnapshot snap) {
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
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection('users').document(_docId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading");
              }
              var userDocument = snapshot.data;
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenSize.height /20),
                      _buildUserProfileImage(userDocument),
                      _buildFullName(userDocument),
                      _buildContainer(userDocument),
                      _buildAds(userDocument),
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
