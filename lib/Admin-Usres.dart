import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'Admin-Ads.dart';
import 'Profile-Other.dart';

class AdminUserPage extends StatefulWidget {
  @override
  _AdminUserPageState createState() => _AdminUserPageState();
}



class _AdminUserPageState extends State<AdminUserPage> {
  Widget but(){
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
                    builder: (BuildContext context) => AdminAdPage(),
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
  Widget _image(String url){
    if(url == ''){
      return Container(
          height: 50,
          width: 50,
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
      width: 50.0,
      height: 50.0,
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
  Widget user(BuildContext context, DocumentSnapshot snapshot){
    return InkWell(
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                child: snapshot['photo'].length<1 || snapshot['photo']==null ? _image('')
                    :_image(snapshot['photo']),
              ),
              title: Text(snapshot['name']),
              subtitle: Text(snapshot['email']),
              trailing: MaterialButton(
                onPressed: () {},
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
              builder: (BuildContext context) => Profile(snapshot.documentID))
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text('Users'),
      ),

      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          but(),
          Flexible(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot){
                Size screenSize = MediaQuery.of(context).size;
                return new ListView.builder(
                  padding: EdgeInsets.all(2),
                  itemExtent: screenSize.height/8,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index)=>user(context, snapshot.data.documents[index]),
                );
              }
            )
          )
        ],
      ),
    );
  }
}
