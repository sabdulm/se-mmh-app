import 'package:flutter/material.dart';


class DrawerOnly extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text("DRAWER HEADER..",style : TextStyle(fontWeight: FontWeight.bold)),
              decoration: new BoxDecoration(
                  color: Colors.orange[700]
              ),
            ),
            new ListTile(
              	leading: const Icon(Icons.account_circle),
				title: const Text('User Profile'),
            ),
            new ListTile(
              	leading: const Icon(Icons.inbox),
				title: const Text('Inbox'),
            ),
            new ListTile(
              	leading: const Icon(Icons.bookmark),
				title: const Text('Bookmarks'),
            ),
            new ListTile(
              	leading: const Icon(Icons.calendar_today),
				title: const Text('View Calender'),
            ),
            new ListTile(
              	leading: const Icon(Icons.add_to_home_screen),
				title: const Text('Post an Ad'),
            ),
            new ListTile(
              	leading: const Icon(Icons.settings),
				title: const Text('Settings'),
            ),
            new ListTile(
              	leading: const Icon(Icons.power_settings_new),
				title: const Text('Logout'),
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