import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:math';
import 'resultAdd.dart';


class AddAdSec extends StatefulWidget {
  AddAd2 temp;
  AddAdSec(this.temp);
  @override
  _AddAdSecState createState() => _AddAdSecState(temp);
}

class _AddAdSecState extends State<AddAdSec> {
  AddAd2 temp;
  _AddAdSecState(this.temp);

  var imgs = <dynamic> [];

  List<FileImage> _buildGalleryImages(){
    List<FileImage> lst = new List<FileImage>();
    for (var i = 0; i < imgs.length; i++) {
      lst.add(FileImage(imgs[i]));
    }
    return lst;
  }

	Widget _buildCoverImage(Size screenSize) => new SizedBox(
    height: screenSize.height/3,
    child: imgs.length>0? new Carousel(
      boxFit: BoxFit.scaleDown,
      images: _buildGalleryImages(),
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(seconds: 2),
      borderRadius: true,
      indicatorBgPadding: 0.0)
      : 
      Image.asset("no_img.png", fit: BoxFit.cover, ),
  );
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("Add images from gallery")
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
              child: _buildCoverImage(screenSize), 
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              // alignment: Alignment.center,
              child: FloatingActionButton(
                heroTag: 'addBtn',
                child: Icon(Icons.add),
                  onPressed: ()  async {
                    var imgFile = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    setState(() {
                      imgs.add(imgFile);
                    });
                    return;
                  }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: 'doneBtn',
                child: Icon(Icons.done),
                  onPressed: () async {
                    // if(imgs.length>0){
                      var imgUrls = [];
                      for (var i = 0; i < imgs.length; i++) {
                        final StorageReference storageRef = FirebaseStorage.instance.ref().child(imgs[i]);
                        final StorageUploadTask uploadTask = storageRef.putFile(File(imgs[i]));
                        final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
                        final String url = (await downloadUrl.ref.getDownloadURL());
                        imgUrls.add(url);
                      }
                      var x = Random() ;
                      var price = x.nextInt(50000) + 10000;
                      Firestore.instance.collection('Property').add({
                        "user" : "users/DHHl7uVMKgYdiBG0cMD1",
                        "name" : temp.title,
                        "description" : temp.description,
                        "photo" : imgUrls,
                        "tags" : temp.tags,
                        "location_lat" : temp.pin.latitude,
                        "location_long" : temp.pin.longitude,
                        "price" : price,
                          
                      })
                      .then((res) => Navigator.push(context, MaterialPageRoute(builder: (context) => ResultAdd(true))))
                      .catchError((err)=>{
                        print(err),
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResultAdd(false))),
                        });
                    // }
                }
              ),
            ),
          )
        ],       
      ),
    );
  }
}