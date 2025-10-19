import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? userLocation;

  getCurrentLocation(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      Position myPosition = await Geolocator.getCurrentPosition();
      userLocation = LatLng(myPosition.altitude, myPosition.longitude);
      notifyListeners();
    } else if (permissionStatus.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Location Permission denied')));
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
