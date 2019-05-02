import 'package:flutter/material.dart';
import 'package:flutter_tags/input_tags.dart';
import 'classes.dart';
import 'maps.dart';
class AddAdState extends State<AddAd> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 23.0, color: Colors.white);
  TextStyle signupstyle = TextStyle(fontFamily: 'Roboto', fontSize: 34.0, color: Color(0xff009aba));
  final TextEditingController _desc = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String description = "", namestr = "";
  String passstr = "", cpassstr = "";
  List<String> tags = [];
  DateTime dateTime = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    final inputTag = InputTags(
      tags: tags,
      onDelete: (t){},
      onInsert: (t){},
      alignment: MainAxisAlignment.start,
      color: Colors.orangeAccent[700],
    );

    final descField = TextField(
      obscureText: false,
      style: style,
      textInputAction: TextInputAction.next,
      controller: _desc,
      onChanged: (text) {
        description = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Description",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final nameField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        namestr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final signUpRdr = InkWell(
      child: Text('Not a member? Sign up!'),
      onTap: () {
        final snackBar = SnackBar(
            content: Text("Redirect to the sign up page."),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change!
              },
            ),
          );

          // Find the Scaffold in the Widget tree and use it to show a SnackBar!
          _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    );
    final nextButon = Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width - 250.0, 0, 0, 0),    
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.orangeAccent[700],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          onPressed: () {
            AddAd1 temp = AddAd1(namestr, description, tags);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyMap(temp),
              ),
            );
          },
          child: Text("Post",
          textAlign: TextAlign.center,
          style: butt.copyWith(
          color: Colors.white, fontWeight: FontWeight.bold)),
       ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: new Text("Post Ad:"),),
      body: Center(

        child: ListView(
          children: <Widget> [
            Container(
            color: Colors.white30,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(height: 50.0),
                  // Text(
                  //   "Sign Up",
                  //   style: signupstyle,
                  // ),
                  SizedBox(height: 50.0),
                  nameField,
                  SizedBox(height: 10.0),
                  descField,
                  SizedBox(height: 10.0),
                  inputTag,
                  SizedBox(
                    height: 20.0,
                  ),
                  nextButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}


class AddAd extends StatefulWidget {
  @override
  AddAdState createState() => new AddAdState();
}
