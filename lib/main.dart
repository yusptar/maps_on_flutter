import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  final Location _location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _currentLocation() async {
    final GoogleMapController controller = mapController;
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      // ignore: prefer_const_constructors
      final marker = Marker(
        markerId: const MarkerId('Omahku'),
        position: const LatLng(-7.9297091, 112.6524402),
        infoWindow: const InfoWindow(
          title: 'Omahku',
          snippet: 'Jl. Teluk Etna II No.78/D',
        ),
      );

      setState(() {
        markers[const MarkerId('Omahku')] = marker;
      });
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(
        bearing: 0,
        target: LatLng(-7.9297091, 112.6524402),
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Location App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          myLocationEnabled: true,
          markers: markers.values.toSet(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _currentLocation,
          label: const Text('My Location'),
          backgroundColor: Colors.green[700],
          icon: const Icon(Icons.location_on),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
