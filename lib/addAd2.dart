import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'dart:io';


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
          )

        ],       
      ),
    );
  }
}