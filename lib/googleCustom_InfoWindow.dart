import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GooglecustomInfowindow extends StatefulWidget {
  const GooglecustomInfowindow({super.key});

  @override
  State<GooglecustomInfowindow> createState() => _GooglecustomInfowindowState();
}

class _GooglecustomInfowindowState extends State<GooglecustomInfowindow> {
  LatLng currentLocation = LatLng(7.0657235, 125.5964753); // This is UM Matina

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  Set<Marker> marker = {};

  List<LatLng> pointOnMap = [
    LatLng(7.0657235, 125.5964753), // This is UM Matina
    LatLng(7.063372985350324, 125.59823710697474), // 24/7 Chicken Matina
    LatLng(7.0643942071924775,
        125.60090389123938), // Jasmine Petron Gasoline Station
    LatLng(7.064488217372279, 125.59876120434855), // Arsonaro Boarding House
  ];

  final List<String> locationNames = [
    'UM Matina',
    '24/7 Chicken Matina',
    'Petron Gasoline Station',
    'Arsonaro Boarding House',
  ];

  final List<String> locationImages = [
    'images/um.png',
    'images/chicken.png',
    'images/petron.png',
    'images/gravahan.png'
  ];

  @override
  void initState() {
    super.initState();
    displayInfo();
  }

  displayInfo() {
    for (int i = 0; i < pointOnMap.length; i++) {
      marker.add(
        Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          position: pointOnMap[i],
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              Container(
                child: Column(
                  children: [
                    Image.asset(
                      locationImages[i],
                      height: 125,
                      width: 250,
                    ),
                    Text(
                      locationNames[i],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pointOnMap[i],
            );
          },
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15,
            ),
            markers: marker,
            onMapCreated: (GoogleMapController controller) {
              customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 155,
            width: 250,
            offset: 40,
          )
        ],
      ),
    );
  }
}
