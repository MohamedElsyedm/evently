import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/widgets/default_text_form_field.dart';
import 'package:evently/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoveTab extends StatefulWidget {
  const LoveTab({super.key});

  @override
  State<LoveTab> createState() => _LoveTabState();
}

class _LoveTabState extends State<LoveTab> {
  late EventsProvider eventsProvider;

  @override
  void initState() {
    super.initState();
    //make code late till build start to call then execute this code
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<String> favoriteEventsIds = Provider.of<UserProvider>(
        context,
        listen: false,
      ).currentUser!.favoriteEventIds;
      eventsProvider.filterFavoriteEvents(favoriteEventsIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    eventsProvider = Provider.of<EventsProvider>(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            DefaultTextFormField(
              hintText: 'Search For Event',
              prefixIconImageName: 'search',
              onChanged: (query) {},
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder: (_, index) =>
                    EventItem(eventsProvider.favoriteEvents[index]),
                separatorBuilder: (_, _) => SizedBox(height: 16),
                itemCount: eventsProvider.favoriteEvents.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
