import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends SearchDelegate{
  Widget _image (String url, Size screenSize){
			return new SizedBox(
				height: screenSize.height/5.5,
				width: screenSize.width/2,
				child: Container(
					decoration: BoxDecoration(
						image: DecorationImage(
							image: NetworkImage(url),
							fit: BoxFit.fill,
						),
					),
				),
			);
	}

	Widget _listItemBuilder (BuildContext context , DocumentSnapshot snapshot, Size screenSize){
		return  Card(
			child: Column(
					children: <Widget>[
						ListTile(
							leading: Container(
								child: snapshot['photo'].length<1 ? Container(height: screenSize.height/4, width: screenSize.width/3,) 
											:_image(snapshot['photo'][0], screenSize),
							),
							title: Text(snapshot['name'] ),
							subtitle: Text(snapshot['description'].substring(0,20)),
					 ),
				],
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
                itemExtent: screenSize.height/4,
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