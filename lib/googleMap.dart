// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Googlemap extends StatefulWidget {
  const Googlemap({super.key});

  @override
  State<Googlemap> createState() => _GooglemapState();
}

class _GooglemapState extends State<Googlemap> {
  static const LatLng googlePark =
      LatLng(37.42409148888462, -122.08806030682587);

  late GoogleMapController googleMapController;
  Set<Marker> marker = {};

  @override
  void initState() {
    super.initState();
    customMarker();
  }

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  void customMarker() {
    BitmapDescriptor.asset(ImageConfiguration(), "images/jeep32.png")
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // This is for the current location of the user
        myLocationButtonEnabled: false,
        markers: marker,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },

        // ------------------------------------------
        initialCameraPosition: CameraPosition(
          target: googlePark,
          zoom: 16,
        ),
      ),

      // This is for the floating action button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          Position position = await currentPosition();
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 16,
                target: LatLng(position.latitude, position.longitude),
              ),
            ),
          );
          marker.clear();
          marker.add(Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('This is my location.'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
              title: 'My Current Location',
              snippet: 'This is University of Mindanao.',
            ),
          ));
          setState(() {});
        },
        child: Icon(
          Icons.my_location,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }

  Future<Position> currentPosition() async {
    bool serviceEnable;
    LocationPermission permission;

    // check if the location service are enabled or not
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Location service is disabled');
    }
    // check the location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is denied permanently');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
