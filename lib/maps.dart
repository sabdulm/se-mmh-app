import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController _controller;

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
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            markers: _markers,
            onCameraMove: _onCameraMove,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });  
            },
          
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                child: const Icon(Icons.add_location),            
                onPressed: () => _getLocation(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),  
                backgroundColor: Colors.transparent,          
                onPressed: () => _getLocation(),
              ),
            ),
          )

        ],
      )       
    );
  }

  void _getLocation() async {
    var pos = await location.getLocation();
    _center = LatLng(pos['latitude'], pos['longitude']);
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: "Undo",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }




}