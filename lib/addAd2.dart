import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:math';
import 'resultAdd.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class AddAdSec extends StatefulWidget {
  final AddAd2 temp;
  AddAdSec(this.temp);
  @override
  _AddAdSecState createState() => _AddAdSecState(temp);
}


class _AddAdSecState extends State<AddAdSec> {
  AddAd2 temp;
  _AddAdSecState(this.temp);
  
  var imgs = <File> [];
  var imgUrls = <String> [];
  bool finishing = false;
  
  List<FileImage> _buildGalleryImages(){
    List<FileImage> lst = new List<FileImage>();
    for (var i = 0; i < imgs.length; i++) {
      lst.add(FileImage(imgs[i]));
    }
    return lst;
  }
  void compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image, height: 500); // choose the size here, it will maintain aspect ratio

    File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));
    imgs.add(compressedImage);
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

  Widget _mainScreen(Size screenSize){
    if (finishing){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
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
              alignment: Alignment.center,
              child: FloatingActionButton(
                heroTag: 'addBtn',
                child: Icon(Icons.add),
                
                  onPressed: ()  async {
                    File imgFile = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if(imgFile!=null){
                      compressImage(imgFile);
                      setState (() {
                      });

                    }
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
                      setState(() {
                        finishing = true;
                      });
                      var imgUrls = [];
                      for (var i = 0; i < imgs.length; i++) {
                        final StorageReference storageRef = FirebaseStorage.instance.ref().child(DateTime.now().toString());
                        final StorageUploadTask uploadTask = storageRef.putFile(imgs[i]);
                        final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
                        final String url = (await downloadUrl.ref.getDownloadURL());
                        imgUrls.add(url);
                      }

                      Geoflutterfire geoPoint = Geoflutterfire();
                      GeoFirePoint point = geoPoint.point(latitude: temp.pin.latitude, longitude: temp.pin.longitude);
                      DocumentReference ref = Firestore.instance.collection('users').document(temp.user.uid);
                      
                      var x = Random() ;
                      var price = x.nextInt(50000) + 10000;
                      Firestore.instance.collection('unApprovedProps').add({
                        "time" : DateTime.now(),
                        "user" : ref,
                        "name" : temp.title,
                        "description" : temp.description,
                        "photo" : imgUrls,
                        "tags" : temp.tags,
                        "location" : point.geoPoint,
                        "price" : price,
                      }).then((res) =>
                      Firestore.instance.runTransaction((transaction) async{
                        DocumentSnapshot freshsnap = await transaction.get(Firestore.instance.collection('users').document(temp.user.uid));
                        await transaction.update(freshsnap.reference,{
                          'properties': FieldValue.arrayUnion([res.documentID]),
                        });
                      }).then((r) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultAdd(true, temp.user)))))
                      .catchError((err)=>{
                        print(err),
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultAdd(false, temp.user))),
                        
                    });
                }
              ),
            ),
          )
        ],       
      );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
      ),
      body: _mainScreen(screenSize), 
    );
  }
}