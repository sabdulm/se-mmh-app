import 'dart:async';

import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(Edit());

class Edit extends StatefulWidget {
  @override
  EditProfile createState() => EditProfile();
}

class EditProfile extends State<Edit> {
  String nameStr = "";
  String emailStr = "";
  String passwordStr = "";
  String cpasswordStr = "";
  String addressStr = "";
  String titleStr = "";
  String mobileStr = "";
  Future<File> imageFile;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    final nameField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
         nameStr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final emailField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        emailStr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      onChanged: (text) {
        passwordStr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final cpasswordField = TextField(
      obscureText: true,
      style: style,
      onChanged: (text) {
        cpasswordStr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Confirm Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final addressField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        addressStr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Address",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final titleField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        titleStr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Title",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final mobileField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        mobileStr = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Mobile",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    Widget profilePic() {
      return Container(
        child: FutureBuilder(
          builder: (context, data) {
            if (data.hasData) {
              return InkWell(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new FileImage(data.data),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(80.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 10.0,
                    )
                  ),
                ),
                onTap:() {
                  imageFile = ImagePicker.pickImage(source: ImageSource.gallery)
                      .whenComplete(() {
                    setState(() {});
                  });
                },
              );
            }
            return InkWell(
              child: Container(
                width: 140.0,
                height: 140.0,
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
              onTap:() {
                imageFile = ImagePicker.pickImage(source: ImageSource.gallery)
                    .whenComplete(() {
                setState(() {});
                });
              },
            );
          },
          future: imageFile,
        ),

      );
    }
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      key: _scaffoldKey,
      // resizeToAvoidBottomPadding: false,
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
                    profilePic(),
                    SizedBox(height: 20.0),
                    nameField,
                    SizedBox(height: 20.0),
                    emailField,
                    SizedBox(height: 20.0),
                    passwordField,
                    SizedBox(height: 20.0),
                    cpasswordField,
                    SizedBox(height: 20.0),
                    addressField,
                    SizedBox(height: 20.0),
                    titleField,
                    SizedBox(height: 20.0),
                    mobileField,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              textColor: Colors.white,
                              color: Colors.orange,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Back'),
                              ),
                            ),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                final snackBar = SnackBar(
                                  content: Text("Name: " + nameStr + ", Email entered: " + emailStr + ", Pass entered: " + passwordStr + ", Address: " + addressStr + ", Title: " + titleStr + ", Mobile: " + mobileStr),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      // Some code to undo the change!
                                    },
                                  ),
                                );

                                // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                _scaffoldKey.currentState.showSnackBar(snackBar);
                              },
                              textColor: Colors.white,
                              color: Colors.orange,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Submit'),
                              ),
                            ),
                          ],
                        ),

                      ],
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
