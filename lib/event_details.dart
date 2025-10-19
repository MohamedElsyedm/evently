import 'package:evently/app_theme.dart';
import 'package:evently/edit_event.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/location_provider.dart';
import 'package:evently/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatefulWidget {
  static const String routName = '/details screen';

  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  EventModel? event;
  GoogleMapController? mapController;
  Set<Circle> circles = {};

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

  Set<Circle> _updateCircleByColor(EventModel event) {
    return circles.map((Circle circle) {
      if (circle.circleId.value == event.id) {
        return Circle(
          circleId: circle.circleId,
          center: LatLng(event.lat ?? 31.45851365, event.long ?? 32.54525465),
          radius: 5,
          fillColor: AppTheme.primary,
          strokeWidth: 10,
          strokeColor: AppTheme.black.withValues(alpha: 0.2),
        );
      } else {
        return Circle(
          circleId: circle.circleId,
          center: LatLng(event.lat ?? 31.45851365, event.long ?? 32.54525465),
          radius: 5,
          fillColor: AppTheme.black,
          strokeWidth: 10,
          strokeColor: AppTheme.black.withValues(alpha: 0.2),
        );
      }
    }).toSet();
  }

  @override
  void initState() {
    super.initState();
    _initiateCircles();
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)!.settings.arguments as EventModel;
    final appLocalization = AppLocalizations.of(context)!;
    Size screenSize = MediaQuery.sizeOf(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    var locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.getCurrentLocation(context);
    circles = _updateCircleByColor(event!);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.eventDetails),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(EditEvent.routName, arguments: event);
            },
            child: Icon(
              Icons.edit_note_rounded,
              size: 24,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              UiUtils.showLoading(
                context,
                canPop: true,
                title: Text(appLocalization.deleteEvent),
                content: Text(appLocalization.deleteEventMessage),
                onTap: deleteEvent,
                buttonText: appLocalization.deleteEvent,
              );
            },
            child: Icon(Icons.delete_outlined, size: 24, color: AppTheme.red),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/${event!.category.imageName}.png',
              height: screenSize.height * 0.25,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              event!.title,
              style: textTheme.headlineSmall!.copyWith(color: AppTheme.primary),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset('assets/icons/date.svg'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('d MMMM yyyy').format(event!.dateTime),
                      style: textTheme.titleMedium!.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                    Text(
                      DateFormat('h:m a').format(event!.dateTime),
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 400,
            width: screenSize.width,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    event!.lat ?? 31.45851365,
                    event!.long ?? 32.54525465,
                  ),
                  zoom: 18,
                ),
                circles: circles,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.description,
            style: textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          Text(event!.description, style: textTheme.titleMedium),
        ],
      ),
    );
  }

  void deleteEvent() {
    Provider.of<EventsProvider>(context, listen: false).deleteEvent(event!);
    UiUtils.hideLoading(context);
    Navigator.pop(context);
  }
}
