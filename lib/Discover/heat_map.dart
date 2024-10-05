// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// class HeatMap extends StatefulWidget {
//   const HeatMap({super.key});
//
//   @override
//   _HeatMapState createState() => _HeatMapState();
// }
//
// class _HeatMapState extends State<HeatMap> {
//   LatLng _initialcameraposition = LatLng(0, 0);
//   late GoogleMapController _controller;
//   bool _isMapInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }
//
//   void _getUserLocation() async {
//     Location location = Location();
//
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     // Check if location service is enabled
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         print('Location service is not enabled');
//         return;
//       }
//     }
//
//     // Check for location permissions
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         print('Location permission is not granted');
//         return;
//       }
//     }
//
//     LocationData locationData = await location.getLocation();
//     setState(() {
//       _initialcameraposition = LatLng(locationData.latitude!, locationData.longitude!);
//       _isMapInitialized = true;
//     });
//
//     _controller.animateCamera(CameraUpdate.newLatLng(_initialcameraposition));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isMapInitialized
//           ? GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _initialcameraposition,
//           zoom: 14.4746,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           _controller = controller;
//         },
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//       )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
