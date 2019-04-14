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
  static LatLng _center = new LatLng(31.489120999999997, 74.3294085);
  LatLng _lastMapPosition = _center;

  CameraPosition _kGooglePlex = CameraPosition(target: _center, zoom: 15);

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    // _updateCenter();
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