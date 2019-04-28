import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'addAd2.dart';
import 'classes.dart';

class MyMap extends StatelessWidget {
  AddAd1 temp;
  MyMap(this.temp);

  @override
  Widget build(BuildContext context) {
    return MapSample(temp);
  }
}

class MapSample extends StatefulWidget {
  AddAd1 temp;
  MapSample(this.temp);
  @override
  State<MapSample> createState() => MapSampleState(temp);
}

class MapSampleState extends State<MapSample> {
  AddAd1 temp;
  MapSampleState(this.temp);
  GoogleMapController _controller;
  Location location = new Location();
  final Set<Marker> _markers = {};
  LatLng droppedPin;
  static LatLng _center = new LatLng(31.489120999999997, 74.3294085);
  LatLng _lastMapPosition = _center;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  MapType _currentMapType = MapType.normal;

  CameraPosition _kGooglePlex = CameraPosition(target: _center, zoom: 15);

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Select your location'),
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
                _controller = controller;
                _controller.getVisibleRegion();
              });  
            },
          
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                child: const Icon(Icons.add_location),   
                heroTag: 'btn1',         
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
                heroTag: 'btn2',
                onPressed: () {},          
                // onPressed: () => _getLocation(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                child: const Icon(Icons.navigate_next),  
                backgroundColor: Colors.blueAccent,
                heroTag: 'btn3',
                onPressed: () {
                  if (_markers.length == 1) {
                    AddAd2 t = AddAd2(temp.title, temp.description, temp.tags, droppedPin);
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddAdSec(t)),
                    );
                  } else {
                    final snackBar = SnackBar(
                      content: Text("Select Property's location"),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                        },
                      ),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                },          
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                child: const Icon(Icons.map),  
                backgroundColor: Colors.blueAccent,
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

  void _getLocation() async {
    var pos = await location.getLocation();
    _center = LatLng(pos['latitude'], pos['longitude']);
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'your pin',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      droppedPin = _lastMapPosition;
    });
  }




}