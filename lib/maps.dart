import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';

class MyMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  final Set<Marker> _markers = {};
  static LatLng _center =  const LatLng(31.488, 74.36);
  LatLng _lastMapPosition = _center;
  // void async getCenter(){
  //   location
  //   var pos = await location.getLocation();
  // }
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _center,
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: _center,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _onCameraMove(CameraPosition position) {

    _lastMapPosition = position.target;
  }
  _updateCenter() async {
    var pos = await location.getLocation();
    _center = LatLng(pos['latitude'], pos['longitude']);
  }
  @override
  Widget build(BuildContext context) {
    _updateCenter();
    return new Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        markers: _markers,
        onCameraMove: _onCameraMove,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        
        },
      ),
      floatingActionButton: FloatingActionButton(
        // label: 'pin',
        onPressed: _getLocation,
        child: const Icon(Icons.add_location),
      ),
    );
  }

  // _animateToUser() async {
  //   location.onLocationChanged();
  //   var pos = await location.getLocation();
  //   mapController
  // }

  void _getLocation(){
    print(_lastMapPosition);
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        // infoWindow: InfoWindow()
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }


}