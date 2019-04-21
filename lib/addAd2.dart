// import 'package:flutter/material.dart';
// import 'classes.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';

// class AddAdSec extends StatelessWidget {
//   AddAd2 t;
//   AddAdSec(this.t);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('hello'),
//       ),
//       body: Text('World'),

//     );
//   }
// }

// // class AddAdSec extends StatefulWidget {
// //   AddAd2 temp;
// //   AddAdSec(this.temp);
// //   @override
// //   _AddAdSecState createState() => _AddAdSecState(temp);
// // }

// // class _AddAdSecState extends State<AddAdSec> {
// //   AddAd2 temp;
// //   _AddAdSecState(this.temp);

// //   List<Future<File>> imageFiles;

// //   pickImageFromGallery(ImageSource source) {
// //     setState(() {
// //       imageFiles.add(ImagePicker.pickImage(source: source));
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return new Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Property'),
// //       ),
// //       body: Stack(
// //         children: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Align(
// //               alignment: Alignment.topCenter,
// //               child: Text("Add images from gallery")
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: InkWell(
// //               child: Container(
// //                 width: 140.0,
// //                 height: 140.0,
// //                 decoration: BoxDecoration(
// //                   image: DecorationImage(
// //                     image: AssetImage('assets/profile.jpg'),
// //                     fit: BoxFit.cover,
// //                   ),
// //                   borderRadius: BorderRadius.circular(80.0),
// //                   border: Border.all(
// //                     color: Colors.white,
// //                     width: 10.0,
// //                   )
// //                 ),
// //               ),

// //               onTap: () {
// //                 pickImageFromGallery(ImageSource.gallery);
// //               },
// //             ),
// //           )

// //         ],       
// //       ),
// //     );
// //   }
// // }