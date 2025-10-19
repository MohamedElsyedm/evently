import 'package:evently/maps_functions/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationServices {
  static Future<LatLng?> pickLocation(BuildContext context) async {
    LatLng pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );
    return pickedLocation;
  }

  static Future<String> getLocationAddress(LatLng latLang) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      latLang.latitude,
      latLang.longitude,
    );
    return '${placeMarks[0].subLocality}, ${placeMarks[0].locality}, ${placeMarks[0].administrativeArea}, ${placeMarks[0].country}, ${placeMarks[0].postalCode}';
  }
}
