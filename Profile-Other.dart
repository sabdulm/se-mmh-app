import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './drawer.dart';
import './property.dart';
import 'chat.dart';

var _docId = '';

class Profile extends StatefulWidget {
  final FirebaseUser user;
  String id;
  Profile(this.id, this.user);
  @override
  ProfileState createState() {
    _docId = id;
    return ProfileState(user);
  }
}

class ProfileState extends State<Profile> {
  final FirebaseUser user;
  ProfileState(this.user);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Profile',
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home : UserProfilePage(user),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final FirebaseUser user;
  UserProfilePage(this.user);
  final Set<String> _saved = new Set<String>();
  final _biggerFont = const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  Widget _buildUserProfileImage(String snap){
    if (snap == '') {
      return Center(
        child: Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('no_img.png'),
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
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(snap),
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

  Widget _buildFullName(String snap) {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    if (snap != null){
      return new Text(
        snap,
        style: _nameTextStyle,
      );
    }
    return new Text('loading');

  }

  void _chat(String _snap, BuildContext context) async{
    DocumentSnapshot snap = await Firestore.instance.collection('users').document(_snap).get();
    DocumentSnapshot snapshot = await Firestore.instance.collection('users').document(user.uid).get();
    List<String> emails= [snap['email'], snapshot['email']];
    emails.sort();
    var key = emails[0] + emails[1];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen(key, snapshot['name'], snapshot['email'], snap['name'],snap['email']))
    );
  }

  Widget _buildContainer(String snap, BuildContext context){
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
                  onPressed: () {
                    _chat(snap, context);
                  },
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
          ],
        )
    );
  }
  Widget _image (String url, Size screenSize){
    if(url == ''){
      return new SizedBox(
          height: 120,
          width: screenSize.width/2.5,
          child: ClipRect(child:new Container(child:new Image.asset("no_img.jpg", fit: BoxFit.fill,)),)
      );
    }
    return new SizedBox(
      height: 120,
      width: screenSize.width/2.5,
      child: new ClipRect(
        child: new Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: new DecorationImage(
              image: new NetworkImage(url),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
  Widget _listItemBuilder (BuildContext context , DocumentSnapshot snapshot, Size screenSize){
    final bool alreadySaved = _saved.contains(snapshot.documentID);
    return new GestureDetector(
      onTap: (){
        Route route = new MaterialPageRoute(builder: (context)=> PropertyPage(snapshot.documentID, 'Property', user));
        Navigator.of(context).push(route);
      },
      child: new Container(
          padding: EdgeInsets.only(left: 5, right: 5,),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  snapshot['photo'].length<1 || snapshot['photo']==null ? _image('',screenSize) :_image(snapshot['photo'][0], screenSize),
                  new VerticalDivider(color: Colors.black,width: 16,),
                  new Container(
                    width: screenSize.width-(screenSize.width/2.5) - 80,
                    height: 120,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text("${snapshot['name'][0].toUpperCase()}${snapshot['name'].substring(1).toLowerCase()}",overflow: TextOverflow.ellipsis ,maxLines: 1, style: _biggerFont,),
                        new Text(
                          snapshot['description'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                          maxLines: 2,
                        ),
                        Spacer(),
                        Container(
                          child:new Text("£${snapshot['price']}.00",style: TextStyle(color: Colors.black87),),
                          alignment: Alignment.bottomRight,
                        ),
                        // snapshot['description'].length>20? new Text("${snapshot['description'].substring(0,20)}..."): new Text(snapshot['description']),
                      ],
                    ),
                  ),
                  new Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: new IconButton(
                      icon: alreadySaved? new Icon(Icons.bookmark) : new Icon(Icons.bookmark_border),
                      color: alreadySaved? Colors.orangeAccent : null,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              new Divider(),
            ],
          )
      ),
    );
  }

  Widget _buildAds() {
    DocumentReference ref = Firestore.instance.collection('users').document(_docId);
    return Flexible(
      child: new StreamBuilder(
        stream: Firestore.instance.collection('Property').where('user', isEqualTo: ref).snapshots(),
        builder: (context, snapshot){
          Size screenSize = MediaQuery.of(context).size;
          if(!snapshot.hasData) return new Center(
            child: new CircularProgressIndicator(),
          );
          return new ListView.builder(
            padding: EdgeInsets.all(2),
            itemExtent: 140,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index)=>_listItemBuilder(context, snapshot.data.documents[index], screenSize),
          );
        },
      ),
    );
  }

  Widget _blocked(Size screenSize, String id, BuildContext context){
    return Column(
      children: <Widget>[
        SizedBox(height: screenSize.height /20),
        _buildUserProfileImage(''),
        _buildFullName('Blocked User'),
        _buildContainer(id, context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerOnly(user),
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
              if(userDocument['block'] == true){
                return _blocked(screenSize, userDocument.documentID, context);
              }
              return Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height /20),
                  _buildUserProfileImage(userDocument['photo']),
                  _buildFullName(userDocument['name']),
                  _buildContainer(userDocument.documentID, context),
                  _buildAds(),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}
