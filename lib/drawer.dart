import 'package:flutter/material.dart';
import 'Admin-Usres.dart';
import 'Profile-Own.dart';
import 'listings.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inbox.dart';
import 'bookmark.dart';
import 'appointment.dart';
// import 'date.dart';
// import 'property.dart';

class DrawerOnly extends StatelessWidget {
  DrawerOnly(this.user);
  final FirebaseUser user;
  final _drawerKey = GlobalKey<ScaffoldState>();

  Widget _admin(BuildContext ctxt, DocumentSnapshot snap) {
    if (snap['isAdmin']) {
      return new ListTile(
        leading: const Icon(Icons.account_circle),
        title: const Text('Admin Page'),
        onTap: () =>
        {
          Navigator.push(
            ctxt,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                new AdminUserPage(user)
            )
          )
        },
      );
    }
    else {
      return new ListTile();
    }
  }

  @override
  Widget build (BuildContext ctxt) {
    if (user != null){
      return new Drawer(
          key: _drawerKey,
          child: StreamBuilder(
              stream: Firestore.instance.collection('users').where(
                  'user', isEqualTo: user.uid).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return new Center(
                  child: new CircularProgressIndicator(),
                );
                return new ListView(
                  children: <Widget>[
                    new DrawerHeader(
                      //child: new Text("DRAWER HEADER..",style : TextStyle(fontWeight: FontWeight.bold)),
                      child: new Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data.documents[0]['photo']),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(80.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 10.0,
                                  )
                              ),
                            ),
                            onTap: () =>
                            {
                            Navigator.push(
                                ctxt,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    new Profile(
                                        snapshot.data.documents[0].documentID,
                                        user)
                                )
                            )
                            },
                          ),
                          Text(snapshot.data.documents[0]['name'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      decoration: new BoxDecoration(
                          color: Colors.orange[700]
                      ),
                    ),
                    new ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () =>
                      {
                        Navigator.popUntil(context, ModalRoute.withName('listings'))
                      },
                    ),
                    new ListTile(
                      leading: const Icon(Icons.inbox),
                      title: const Text('Inbox'),
                      onTap: () =>
                      {
                      Navigator.push(
                          ctxt,
                          MaterialPageRoute(
                              builder: (ctxt) =>
                                  InboxPage(snapshot.data.documents[0]['name'],
                                      snapshot.data.documents[0]['email'],
                                      user))
                      )
                      },
                    ),
                    new ListTile(
                      leading: const Icon(Icons.bookmark),
                      title: const Text('Bookmarks'),
                      onTap: () =>{
                        Navigator.pushNamed(
                          ctxt,
                          MyBookmarkPage.routeName,
                          arguments: user,
                        )
                      },
                    ),
                    new ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('View Calender'),
                      onTap: () {
                        Navigator.push(ctxt,
                         MaterialPageRoute(
                           builder: (ctxt)=>AppointmentRenderer(snapshot.data.documents[0]['email'])
                         )
                         );
                      },
                    ),
                    new ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                    ),
                    new ListTile(
                        leading: const Icon(Icons.power_settings_new),
                        title: const Text('Logout'),
                        onTap: () {
                          try {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                              ctxt,
                              MaterialPageRoute(builder: (ctxt) => MyApp()),
                            );
                          }
                          catch (e) {}
                        }
                    ),
                    _admin(ctxt, snapshot.data.documents[0]),
                  ],
                );
              }
          )
      );
    }
    else {
      return new Drawer(
          key: _drawerKey,
          child:new ListView(
                  children: <Widget>[
                    new DrawerHeader(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("GUEST",style : TextStyle(fontWeight: FontWeight.bold)),
                        ],
                       ),
                      decoration: new BoxDecoration(
                          color: Colors.orange[700]
                      ),
                    ),
                    new ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () =>
                      {
                        Navigator.pushNamed(
                          ctxt,
                          MyHomePage.routeName,
                          arguments: user,
                        )
                      },
                    ),
                    new ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                    ),
                    new ListTile(
                        leading: const Icon(Icons.create),
                        title: const Text('Login/Signup'),
                        onTap: () {
                          try {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                              ctxt,
                              MaterialPageRoute(builder: (ctxt) => MyApp()),
                            );
                          }
                          catch (e) {}
                        }
                    ),

                  ],
                ),

      );
    }
  }
}
