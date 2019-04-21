import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAd1 {
  final String title;
  final String description;
  final List<String> tags;
  AddAd1(this.title, this.description, this.tags);
}

class AddAd2 {
  final String title;
  final String description;
  final List<String> tags;
  final LatLng pin;
  AddAd2(this.title, this.description, this.tags, this.pin); 
}