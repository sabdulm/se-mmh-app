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
  _AdminUserPageState(this.User);
  final FirebaseUser User;
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
                    builder: (BuildContext context) => AdminAdPage(User),
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

  void _delete(String snap) async{
    DocumentReference ref = Firestore.instance.collection('users').document(snap);
    DocumentSnapshot snapshot = await ref.get();
    for(var i = 0; i < snapshot['properties'].length; i++){
      DocumentReference prop = Firestore.instance.collection('Property').document(snapshot['properties'][i]);
      if(prop == null){
        prop = Firestore.instance.collection('unApprovedProps').document(snapshot['properties'][i]);
      }
      prop.delete();
    }
    ref.delete();
  }
  Widget _image(String url, Size screenSize){
    if(url == ''){
      return Container(
        height: screenSize.height/10,
        width: screenSize.height/10,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('no_img.png'),
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
      width: screenSize.height/10,
      height: screenSize.height/10,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
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
              trailing: MaterialButton(
                onPressed: () {
                  _delete(snapshot.documentID);
                },
                textColor: Colors.white,
                color: Colors.orange,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Delete'),
                ),
              ),
            )
          ],
        ),
      ),
      onTap:() => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(snapshot.documentID, User))
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerOnly(User),
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
                    return new ListView.builder(
                      padding: EdgeInsets.all(2),
                      itemExtent: screenSize.height/8,
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
