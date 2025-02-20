import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Googlemap extends StatefulWidget {
  const Googlemap({super.key});

  @override
  State<Googlemap> createState() => _GooglemapState();
}

class _GooglemapState extends State<Googlemap> {
  // static Location locationController =
  //     new Location(); // Controller for access your current location
  // LatLng? currentPosition = null; // Googleplex location

  // static const LatLng microsoft =
  //     LatLng(37.412434669927016, -122.07110874660697);
  static const LatLng googlePark =
      LatLng(37.42409148888462, -122.08806030682587);

  // This is for the actual camera position follow the current location of the user
  // final Completer<GoogleMapController> mapController =
  //     Completer<GoogleMapController>();

  // Map<PolylineId, Polyline> polylines =
  //     {}; // This is for the polylines on the map

  // final String googleApiKey =
  //     'AIzaSyCVyTKbTZ_5BhkcTscBQ3fgJCgqeHFFayE'; // Store securely

  late GoogleMapController googleMapController;
  Set<Marker> marker = {};

  @override
  void initState() {
    super.initState();
    // getLocationUpdates().then(
    //   (_) => {
    //     getPolyLinePoints().then((coordinates) => {
    //           generatePolyLineFromPoints(coordinates),
    //         }),
    //   },
    // );
    // getLocationUpdates();
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
        // markers: {
        //   // Marker(
        //   //   markerId: MarkerId('Google Park'),
        //   //   icon: customIcon,
        //   //   position: googlePark,
        //   //   draggable: true,
        //   //   onDragEnd: (value) {},
        //   //   infoWindow: InfoWindow(
        //   //     title: 'Google Park',
        //   //     snippet: 'This is Google Park.',
        //   //   ),
        //   // ),
        // },
      ),

      // This is for the floating action button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          Position position = await currentPosition();
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 14,
                target: LatLng(position.latitude, position.longitude),
              ),
            ),
          );
          marker.clear();
          marker.add(Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('This is my location.'),
            position: LatLng(position.latitude, position.longitude),
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

  // This function is for the actual camera movement of the map
  // Future<void> cameraPosition(LatLng position) async {
  //   final GoogleMapController controller = await mapController.future;
  //   CameraPosition newCameraPosition = CameraPosition(
  //     target: position,
  //     zoom: 16,
  //   );
  // }

  // Future<void> getLocationUpdates() async {
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;

  //   serviceEnabled = await locationController.serviceEnabled();
  //   if (serviceEnabled) {
  //     serviceEnabled = await locationController.requestService();
  //   } else {
  //     return;
  //   }

  //   permissionGranted = await locationController.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await locationController.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   locationController.onLocationChanged.listen((LocationData currentLocation) {
  //     if (currentLocation.latitude != null &&
  //         currentLocation.longitude != null) {
  //       setState(() {
  //         currentPosition =
  //             LatLng(currentLocation.latitude!, currentLocation.longitude!);

  //         // print(currentPosition);
  //         cameraPosition(currentPosition!);
  //       });
  //     }
  //   });
  // }

  // // This is the function dedicated for adding polylines on the map
  // Future<List<LatLng>> getPolyLinePoints() async {
  //   List<LatLng> polylineCoordinates = [];
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     request: PolylineRequest(
  //       origin: PointLatLng(googlePark.latitude, googlePark.longitude),
  //       destination: PointLatLng(microsoft.latitude, microsoft.longitude),
  //       mode: TravelMode.driving,
  //       googleApiKey: googleApiKey, // Add your API key here
  //     ),
  //   );

  //   if (result.points.isNotEmpty) {
  //     for (var point in result.points) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }
  //   } else {
  //     debugPrint("Polyline Error: ${result.errorMessage}");
  //   }

  //   return polylineCoordinates;
  // }

  // void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
  //   PolylineId id = PolylineId('poly');
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     points: polylineCoordinates,
  //     color: Colors.orange,
  //     width: 8,
  //   );

  //   setState(() {
  //     polylines[id] = polyline;
  //   });
  // }
}
