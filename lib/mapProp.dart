import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'addAd2.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
// import 'classes.dart';

class PropertyMap extends StatelessWidget {
  // AddAd1 temp;
  // PropertyMap(this.temp);
  GeoPoint point;
  String name;
  PropertyMap(this.point, this.name);
  @override
  Widget build(BuildContext context) {
    return PropMap(point, name);
  }
}

class PropMap extends StatefulWidget {
  GeoPoint point;
  String name;
  PropMap(this.point, this.name);
  @override
  State<PropMap> createState() => PropMapState(point, name);
}

class PropMapState extends State<PropMap> {
  GeoPoint point;
  String name;
  PropMapState(this.point, this.name);
  // AddAd1 temp;
  // PropMapState(this.temp);
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  final Set<Marker> _markers = {};
  static LatLng _center = new LatLng(31.489120999999997, 74.3294085);
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;


  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Future<void> _moveToPos() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 192.8334901395799,
      target: _center,
      tilt: 0,
      zoom: 15)));
  }

  @override
  Widget build(BuildContext context) {
    _center = LatLng(point.latitude, point.longitude);

    CameraPosition _kGooglePlex = CameraPosition(target: _center, zoom: 15);


    _markers.add(Marker(
        markerId: MarkerId(_center.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: name,
        ),
        icon: BitmapDescriptor.defaultMarker,
    ));


    return new Scaffold(
      appBar: AppBar(
        title: Text('Property Location'),
      ),
      body: Stack(

        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            markers: _markers,
            onCameraMove: _onCameraMove,
            mapType: _currentMapType,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller.complete(controller);
              });  
            },
          
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton.icon(
                label: Text('Show Location'),
                icon: Icon(Icons.location_searching),  
                color: Colors.orangeAccent, 
                onPressed: _moveToPos,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                child: const Icon(Icons.map),  
                backgroundColor: Colors.orangeAccent,
                heroTag: 'changeMapType',
                onPressed: () {
                  setState(() {
                    _currentMapType = _currentMapType == MapType.normal
                      ? MapType.satellite
                      : MapType.normal;
                  });
                },          
              ),
            ),
          ),
        ],
      )       
    );
  }




}