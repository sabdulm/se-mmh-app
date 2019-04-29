import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'property.dart';

class Search extends SearchDelegate{
  final _biggerFont = const TextStyle(
															fontSize: 18.0,
															fontWeight: FontWeight.bold,
														);
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
		return new GestureDetector(
      onTap: (){
            Route route = new MaterialPageRoute(builder: (context)=> PropertyPage(snapshot.documentID, 'Property'));
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
                  width: screenSize.width-(screenSize.width/2.5) - 70,
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
              ],
            ),
            new Divider(),
          ],
        )
      ),
    );
	}

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    List<String> queryKeys = query.toLowerCase().split(" ");
    return StreamBuilder( 
        stream: Firestore.instance.collection('Property').snapshots(),
				// stream: searchResult(query),
				builder: (context, snapshot){

              Size screenSize = MediaQuery.of(context).size;
              if(!snapshot.hasData ) return new Center(
                child: new CircularProgressIndicator(),
              );
              print(snapshot.data.documents.length);
              print(query);
              var temp =[];
              for (var doc in snapshot.data.documents) {
                if(queryKeys.contains( doc['name'].toLowerCase())){
                  temp.add(doc);
                  continue;
                }
                for (var item in doc['tags']) {
                  if(queryKeys.contains(item.toLowerCase())){
                    temp.add(doc);
                    break;
                  } 
                }
                  
              }
              return new ListView.builder(
                padding: EdgeInsets.all(2),
                itemExtent: 140,
                itemCount: temp.length,
                itemBuilder: (context, index) => _listItemBuilder(context, temp[index], screenSize),
              );
            },
          ); 
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}