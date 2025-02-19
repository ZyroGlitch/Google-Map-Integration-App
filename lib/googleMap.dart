import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Googlemap extends StatefulWidget {
  const Googlemap({super.key});

  @override
  State<Googlemap> createState() => _GooglemapState();
}

class _GooglemapState extends State<Googlemap> {
  static Location locationController =
      new Location(); // Controller for access your current location
  LatLng? currentPosition = null; // Googleplex location

  static const LatLng microsoft =
      LatLng(37.412434669927016, -122.07110874660697);
  static const LatLng googlePark =
      LatLng(37.42409148888462, -122.08806030682587);

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);

          print(currentPosition);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null
          ? Center(
              child: Text('Loading...'),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: googlePark,
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('Google Park'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: googlePark,
                ),
                Marker(
                  markerId: MarkerId('Googleplex'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentPosition!,
                ),
                Marker(
                  markerId: MarkerId('Shoreline Amphitheatre'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: microsoft,
                ),
              },
            ),
    );
  }
  // TagetPlatform.windows is not yet supported by the maps plugin
}
