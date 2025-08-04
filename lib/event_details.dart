import 'package:evently/app_theme.dart';
import 'package:evently/edit_event.dart';
import 'package:evently/firebase_service.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  static const String routName = '/details screen';

  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  EventModel? event;

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)!.settings.arguments as EventModel;
    Size screenSize = MediaQuery.sizeOf(context);
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EditEvent.routName, arguments: event)
                  .then((_) => setState(() {}));
            },
            child: Icon(
              Icons.edit_note_rounded,
              size: 24,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: deleteEvent,
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
          Text('Description', style: textTheme.titleMedium),
          SizedBox(height: 8),
          Text(event!.description, style: textTheme.titleMedium),
        ],
      ),
    );
  }

  void deleteEvent() {
    FirebaseService.deleteEvent(event!)
        .then((_) {
          UiUtils.showSuccessMessage('Event deleted successfully');
          Navigator.pop(context);
        })
        .catchError((_) {
          UiUtils.showErrorMessage('Something went wrong');
        });
  }
}
