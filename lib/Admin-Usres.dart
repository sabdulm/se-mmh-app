import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'Admin-Ads.dart';
import 'Profile-Other.dart';

class AdminUserPage extends StatefulWidget {
  AdminUserPage(this.user);
  final FirebaseUser user;
  @override
  _AdminUserPageState createState() => _AdminUserPageState(user);
}



class _AdminUserPageState extends State<AdminUserPage> {
  _AdminUserPageState(this._user);
  final FirebaseUser _user;
  Widget but(Size screenSize){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () => {},
              textColor: Colors.white,
              color: Colors.orange,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text('Users'),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AdminAdPage(_user),
                  )),
              textColor: Colors.white,
              color: Colors.orange,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text('Ads'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _block(String snap) async{
    Firestore.instance.collection('users').document(snap).updateData({
      "block" : true,
    });
  }

  void _unblock(String snap) async{
    Firestore.instance.collection('users').document(snap).updateData({
      "block" : false,
    });
  }

  Widget block(DocumentSnapshot snap) {
    if(snap['block'] == false){
      return MaterialButton(
        onPressed: () {
          _block(snap.documentID);
        },
        textColor: Colors.white,
        color: Colors.orange,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Text('Block'),
        ),
      );
    } else {
      return MaterialButton(
        onPressed: () {
          _unblock(snap.documentID);
        },
        textColor: Colors.white,
        color: Colors.orange,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Text('Unblock'),
        ),
      );
    }
  }

  Widget _image(String url, Size screenSize){
    if(url == ''){
      return Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('boy.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              color: Colors.white,
              width: 4.0,
            )
        ),
      );
    }
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(url),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 4.0,
          )
      ),
    );
  }
  Widget user(BuildContext context, DocumentSnapshot snapshot, Size screenSize){
    return InkWell(
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                child: snapshot['photo'].length<1 || snapshot['photo']==null ? _image('', screenSize)
                    :_image(snapshot['photo'], screenSize),
              ),
              title: Text(snapshot['name']),
              subtitle: Text(snapshot['email']),
              trailing: block(snapshot)
            )
          ],
        ),
      ),
      onTap:() => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(snapshot.documentID, _user))
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerOnly(_user),
      appBar: AppBar(
        title: Text('Users'),
      ),

      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          but(screenSize),
          Flexible(
              child: StreamBuilder(
                  stream: Firestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot){
                    Size screenSize = MediaQuery.of(context).size;
                    if(snapshot.data==null){
                      return CircularProgressIndicator();
                    }
                    return new ListView.builder(
                      padding: EdgeInsets.all(2),
                      itemExtent: 80,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index)=>user(context, snapshot.data.documents[index], screenSize),
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}
