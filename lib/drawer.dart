import 'package:flutter/material.dart';

class MyState extends State<MyHomePage> {
	final List<advertisement> listings = <advertisement>[
    advertisement(name: 'bungla' , photo_url: 'https://assets.site-static.com/userFiles/657/image/Camelot_Development_Northbridge.jpg',description:'wow what a house'),
    advertisement(name: 'bungla1' , photo_url: 'https://westvancouver.ca/sites/default/files/styles/grid-9/public/coachhouse_0.jpg?itok=G4DGtlrw',description:'shit house'),
    advertisement(name: 'bungla2' , photo_url: 'https://eieihome.com/articles/wp-content/uploads/2018/04/architecture-building-driveway-186077.jpg',description:'Beautiful'),
  ];
  List<advertisement> items = List<advertisement>();
  final Set<advertisement> _saved = new Set<advertisement>(); 

  int _perpage =1;
  int _current = 0;
  final _biggerFont = const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            );
  
  @override
  void initState() {
      super.initState();
      setState(() {
          items.addAll(listings.getRange(_current, _current + _perpage));
          _current = _current + _perpage;
      });
  }
  void loadMore() {
    setState(() {
      if (_current >= listings.length ){
        return;
      }else if((_current + _perpage )> listings.length) {
          items.addAll(
            listings.getRange(_current, (listings.length-1)));
      } else {
        items.addAll(
            listings.getRange(_current, _current + _perpage));
      }

      _current = _current + _perpage;
    });
  }
  void bookmark(){

  }
  Widget _listItemBuilder (BuildContext context , int index){
		final bool alreadySaved = _saved.contains(items[index]);
    if ((index < items.length)) {
		//   return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
		// 	children: <Widget>[
				
    //     new Image.network(items[index].photo_url,
    //       alignment: Alignment.centerLeft,
    //       fit: BoxFit.fitHeight,
    //       width: 100,
    //       ),
		// 		Container(
		// 			child: Text(
    //         items[index].name,
    //         style: _biggerFont,
    //         textAlign: TextAlign.center,
    //         ),
		// 		),
		// 	],
		// );
    return  Card(
      child: Column(
          children: <Widget>[ListTile(
              leading: new Image.network(items[index].photo_url,
                  height: 120,
                  width: 160,
                  alignment: Alignment.bottomCenter,
                  ),
              title: Text(items[index].name , style: _biggerFont,),
              subtitle: Text(items[index].description),
              trailing: Icon(
                alreadySaved? Icons.bookmark : Icons.bookmark_border,
                color: alreadySaved? Colors.orangeAccent : null,  
                ),
                onTap: () {      // Add 9 lines from here...
                setState(() {
                    if (alreadySaved) {
                      _saved.remove(items[index]);
                    } else { 
                      _saved.add(items[index]); 
                    }
                  });
                },
            ),
          ],
        ),
      );
		} else {
		  return Container(
             child: Text("End.", textAlign: TextAlign.center,),
            );
		}
		// return Text(listings[index].name);
	}

	@override
	Widget build (BuildContext ctxt) {
		return new Scaffold(
			drawer: new DrawerOnly(),
			appBar: new AppBar(
				title: new Text("Drawer Demo"),
			),
			body:NotificationListener<ScrollNotification>( 
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            loadMore();
          }
        },
        child: new ListView.builder(
            itemExtent: 140.0,
            padding: EdgeInsets.all(10.0),
            itemCount: (_current < (listings.length-1)) ? items.length + 1 : items.length,
            itemBuilder: _listItemBuilder,

          ),
      ), //<-------add lists here!!!
			floatingActionButton: FloatingActionButton(
				tooltip: 'Increment',
				child: Icon(Icons.photo_filter),
			),
		);
	}
}



class MyHomePage extends StatefulWidget {
  @override
  MyState createState() => new MyState();
}
class advertisement {
	const advertisement({this.name,this.photo_url,this.description});
	final String name;
	final String photo_url;
	final String description;
}


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