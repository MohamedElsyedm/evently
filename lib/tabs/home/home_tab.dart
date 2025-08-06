import 'package:evently/event_details.dart';
import 'package:evently/firebase_service.dart';
import 'package:evently/models/category_model.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/tabs/home/home_header.dart';
import 'package:evently/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    return Column(
      children: [
        HomeHeader(),
        SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) => InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                EventDetails.routName,
                arguments: eventsProvider.displayedEvents[index],
              ),
              child: EventItem(eventsProvider.displayedEvents[index]),
            ),
            separatorBuilder: (_, _) => SizedBox(height: 16),
            itemCount: eventsProvider.displayedEvents.length,
          ),
        ),
      ],
    );
  }
}
