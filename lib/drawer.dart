import 'package:flutter/material.dart';
import 'Admin-Usres.dart';
import 'Profile-Own.dart';
import 'listings.dart';
// import 'date.dart';
// import 'property.dart';

class DrawerOnly extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Drawer(
        child: new ListView(
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
                    onTap: () => {
                      Navigator.pushReplacement(
                          ctxt,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new UserProfilePage()
                          )
                      )
                    },
                  ),
                  Text("DRAWER HEADER..",style : TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              decoration: new BoxDecoration(
                  color: Colors.orange[700]
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () =>{
                Navigator.push(
                  ctxt,
                  MaterialPageRoute(
                    builder: (ctxt) => MyHomePage())
                )
              },
            ),
            new ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('Inbox'),
              onTap: (){
                Navigator.of(ctxt).pushNamed('inbox');
             },
            ),
            new ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Bookmarks'),
//              onTap: () =>{
//                Navigator.pushReplacement(
//                    ctxt,
//                    new MaterialPageRoute(
//                        builder: (BuildContext context) => new MyApp()
//                    )
//                )
//              },
            ),
            new ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('View Calender'),
              onTap: (){
                Navigator.of(ctxt).pushNamed('calendar');
              },
            ),
            new ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            new ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: const Text('Logout'),
            ),
            new ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Admin Page'),
              onTap: () =>{
                Navigator.pushReplacement(
                    ctxt,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new AdminUserPage()
                    )
                )
              },
            ),
            // new ListTile(
            //   title: new Text("Item => 2"),
            //   onTap: () {
            //     Navigator.pop(ctxt);
            //     Navigator.push(ctxt,
            //         new MaterialPageRoute(builder: (ctxt) => new SecondPage()));
            //   },
            // ),
          ],
        )
    );
  }
}
