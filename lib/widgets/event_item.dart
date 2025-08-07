import 'package:evently/app_theme.dart';
import 'package:evently/event_details.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/settings_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventItem extends StatelessWidget {
  EventModel event;

  EventItem(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    bool isFavorite = userProvider.checkIsFavoriteEvent(event.id);
    Size screenSize = MediaQuery.sizeOf(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: settingsProvider.isDark
            ? Border.all(color: AppTheme.primary)
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () => Navigator.of(
              context,
            ).pushNamed(EventDetails.routName, arguments: event),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/${event.category.imageName}.png',
                height: screenSize.height * 0.25,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: settingsProvider.isDark
                  ? AppTheme.backgroundDark
                  : AppTheme.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '${event.dateTime.day}',
                  style: textTheme.titleLarge!.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(event.dateTime),
                  style: textTheme.titleSmall!.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            width: screenSize.width - 32,
            bottom: 8,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: settingsProvider.isDark
                    ? AppTheme.backgroundDark
                    : AppTheme.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      if (isFavorite) {
                        userProvider.removeEventFromFavorites(event.id);
                        Provider.of<EventsProvider>(
                          context,
                          listen: false,
                        ).filterFavoriteEvents(
                          userProvider.currentUser!.favoriteEventIds,
                        );
                      } else {
                        userProvider.addEventToFavorites(event.id);
                      }
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_outline,
                      size: 24,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
