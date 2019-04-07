import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
	Widget _listItemBuilder (BuildContext context , int index){
		return Stack(
			children: <Widget>[
				new Image.network(listings[index].photo_url),
				Center(
					child: Text(listings[index].name)
				),
			],
		);
		// return Text(listings[index].name);
	}


	@override
	Widget build (BuildContext ctxt) {
		return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text("Drawer Demo"),
			),
			body: new ListView.builder(
					itemCount: listings.length,
					itemExtent: 100.0,
					itemBuilder: _listItemBuilder,

				), //<-------add lists here!!!
			floatingActionButton: FloatingActionButton(
				tooltip: 'Increment',
				child: Icon(Icons.photo_filter),
			),
		);
	}
}


class advertisement {
	const advertisement({this.name,this.photo_url,this.description});
	final String name;
	final String photo_url;
	final String description;
}

final List<advertisement> listings = <advertisement>[
	advertisement(name: 'bungla' , photo_url: 'https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg',description:'wow what a house'),
	advertisement(name: 'bungla1' , photo_url: 'https://westvancouver.ca/sites/default/files/styles/grid-9/public/coachhouse_0.jpg?itok=G4DGtlrw',description:'shit house'),
	advertisement(name: 'bungla2' , photo_url: 'https://eieihome.com/articles/wp-content/uploads/2018/04/architecture-building-driveway-186077.jpg',description:'Beautiful'),
];

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