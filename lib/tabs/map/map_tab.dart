import 'package:evently/app_theme.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/location_provider.dart';
import 'package:evently/tabs/map/map_event_item.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTab extends StatefulWidget {
  MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  GoogleMapController? mapController;
  Set<Circle> circles = {};

  _centerMap(LatLng newLatLang) {
    mapController?.animateCamera(CameraUpdate.newLatLng(newLatLang));
  }

  _initiateCircles() {
    var eventListProvider = Provider.of<EventsProvider>(context, listen: false);
    for (var event in eventListProvider.displayedEvents) {
      if (event.lat != null && event.long != null) {
        circles.add(
          Circle(
            circleId: CircleId(event.id),
            center: LatLng(event.lat!, event.long!),
            radius: 10,
            fillColor: AppTheme.black,
            strokeWidth: 20,
            strokeColor: AppTheme.black.withValues(alpha: 0.2),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initiateCircles();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var eventListProvider = Provider.of<EventsProvider>(context);
    var locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.userLocation == null) {
      locationProvider.getCurrentLocation(context);
    }

    return eventListProvider.displayedEvents.isEmpty
        ? const Center(
            child: Column(children: [Text("There is no Events added")]),
          )
        : Stack(
            children: [
              GoogleMap(
                circles: circles,
                onMapCreated: (controller) {
                  mapController = controller;
                },
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target:
                      locationProvider.userLocation ??
                      const LatLng(32.25556842, 29.46321234523),
                  zoom: 18,
                ),
              ),
              PositionedDirectional(
                top: 40,
                end: 20,
                child: ElevatedButton(
                  onPressed: () {
                    _centerMap(locationProvider.userLocation!);
                  },
                  style: ElevatedButton.styleFrom(shape: CircleBorder()),
                  child: Icon(
                    Icons.my_location,
                    size: 20,
                    color: AppTheme.white,
                  ),
                ),
              ),
              PositionedDirectional(
                bottom: 0,
                end: 0,
                start: 0,
                child: SizedBox(
                  height: height * 0.267,
                  width: 0.83,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.02,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        var selectedEvent =
                            eventListProvider.displayedEvents[index];
                        if (selectedEvent.lat != null &&
                            selectedEvent.long != null) {
                          _centerMap(
                            LatLng(selectedEvent.lat!, selectedEvent.long!),
                          );
                          setState(() {});
                        }
                      },
                      child: MapEventItem(
                        event: eventListProvider.displayedEvents[index],
                      ),
                    ),
                    itemCount: eventListProvider.displayedEvents.length,
                  ),
                ),
              ),
            ],
          );
  }
}
