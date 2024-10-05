import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:ui';

const String google_api_key = "AIzaSyAc3U0nEP1kt2piGXrgPrNbJU6kENFf6L0";
FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

Size size = view.physicalSize / view.devicePixelRatio;
double deviceWidth = size.width;
double deviceHeight = size.height;


class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LocationData? _userLocation;

  // This function will get user location
  Future<void> _getUserLocation(Timer t) async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        t.cancel();
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        t.cancel();
        return;
      }
    }

    var locationData = await location.getLocation();
    setState(() {
      _userLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getGPS(),
          ],
        ),
      ),
    );
  }

  Widget getGPS() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          onPressed: () {
            // while (true) {
            //   _getUserLocation();
            //   print('Your latitude: ${_userLocation?.latitude}');
            //   print('Your longitude: ${_userLocation?.longitude}');
            //   sleep(const Duration(seconds: 5));
            // }
            Timer t = Timer(const Duration(seconds: 1), () { });
            _getUserLocation(t);
            Timer.periodic(const Duration(seconds: 5), (Timer t) {
              _getUserLocation(t);
              print('Your latitude: ${_userLocation?.latitude}');
              print('Your longitude: ${_userLocation?.longitude}');

              // insertRecord();

            });
          },
          child: const Text("GPS Locator"),
        ),
        const SizedBox(height: 25),
        // Display latitude & longitude
        _userLocation != null ? Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.vertical,
          children: [
            Text('Latitude: ${_userLocation?.latitude}', style: TextStyle(
                fontSize: deviceWidth * 0.075
            )),
            const SizedBox(height: 10),
            Text('Longitude: ${_userLocation?.longitude}', style: TextStyle(
                fontSize: deviceWidth * 0.075
            ),)
          ],
        ) : const Text('Please enable location service and grant permission')
      ],
    );
  }
}
