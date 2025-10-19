import 'package:evently/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationPicker extends StatefulWidget {
  static const String routName = '/location';

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, selectedLocation);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: GoogleMap(
        onTap: (LatLng latLang) {
          selectedLocation = latLang;
          setState(() {});
        },
        initialCameraPosition: CameraPosition(
          target:
              locationProvider.userLocation ??
              const LatLng(30.741873, 31.8771837),
          zoom: 19,
        ),
        // set is list but it cancel the duplications
        markers: selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId("selected location"),
                  position: selectedLocation!,
                ),
              }
            : {},
      ),
    );
  }
}
