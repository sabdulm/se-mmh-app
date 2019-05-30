import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class Edit extends StatefulWidget {
  final FirebaseUser user ;
  Edit(this.user);
  @override
  EditProfile createState() => EditProfile(user);
}

class EditProfile extends State<Edit> {
  final FirebaseUser user ;
  EditProfile(this.user);
  String nameStr = "";
  String emailStr = "";
  String passwordStr = "";
  String cpasswordStr = "";
  String addressStr = "";
  String titleStr = "";
  String mobileStr = "";
  File img = null;
  void compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image, height: 500); // choose the size here, it will maintain aspect ratio

    File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));
    this.img=compressedImage;
  }
  Widget profilePic(String photo) {
    if (img == null) {
      if (photo == '') {
        return InkWell(
          child: Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('no_img.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(80.0),
                border: Border.all(
                  color: Colors.white,
                  width: 10.0,
                )
            ),
          ),
          onTap: () async {
            img = await ImagePicker.pickImage(source: ImageSource.gallery)
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
                image: NetworkImage(photo),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                width: 10.0,
              )
          ),
        ),
        onTap: () async {
          img = await ImagePicker.pickImage(source: ImageSource.gallery)
              .whenComplete(() {
            setState(() {});
          });
        },
      );
    } else {
      return InkWell(
        child: Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(img),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                width: 10.0,
              )
          ),
        ),
        onTap: () async {
          img = await ImagePicker.pickImage(source: ImageSource.gallery)
              .whenComplete(() {
            setState(() {});
          });
        },
      );
    }
  }
  void updatePhoto(String snap, String url) async{
    if (img!=null) {
      final StorageReference storageRef = FirebaseStorage.instance.ref().child(
          DateTime.now().toString());
      compressImage(img);
      final StorageUploadTask uploadTask = storageRef.putFile(img);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      if(url!= ''){
        // StorageReference photoRef = await FirebaseStorage().getReferenceFromUrl(url);
        // photoRef.delete();
      }
      Firestore.instance.collection('users').document(snap).updateData({
        'photo': url,
      });
      
    }
  }
  void update(String name, String address, String mobile, String title, String snap) async{
    Firestore.instance.collection('users').document(snap).updateData({
      'name': name,
      'mobile': mobile,
      'address': address,
      'title': title,
    });
  }
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
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
    return Scaffold(
      drawer: DrawerOnly(user),
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      // resizeToAvoidBottomPadding: false,
      body: StreamBuilder(
          stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
          builder: (context, snapshot){
            if (!snapshot.hasData) {
            return Text("Loading");
            }
            return Center(
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
                            profilePic(snapshot.data['photo']),
                            SizedBox(height: 20.0),
                            nameField,
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
                                        if(nameStr == ''){
                                          nameStr = snapshot.data['name'];
                                        }
                                        if(addressStr == ''){
                                          addressStr = snapshot.data['address'];
                                        }
                                        if(mobileStr == ''){
                                          mobileStr = snapshot.data['mobile'];
                                        }
                                        if(titleStr == ''){
                                          titleStr = snapshot.data['title'];
                                        }
                                        update(nameStr, addressStr, mobileStr, titleStr, snapshot.data.documentID);
                                        updatePhoto(snapshot.data.documentID,snapshot.data['url']);
                                        Navigator.pop(context);
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
            );
          }
      )
    );
  }
}
