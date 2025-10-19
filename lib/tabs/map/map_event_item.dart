import 'package:evently/app_theme.dart';
import 'package:evently/models/event_model.dart';
import 'package:flutter/material.dart';

class MapEventItem extends StatelessWidget {
  final EventModel event;
  const MapEventItem({required this.event});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.02,
      ).copyWith(bottom: height * 0.05, right: width * 0.16),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.02,
        horizontal: width * 0.02,
      ),
      height: height * 0.2,
      constraints: BoxConstraints(maxWidth: width * 0.83),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.4),
        border: Border.all(width: 2, color: AppTheme.primary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 10,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/${event.category.imageName}.png',
              width: width * 0.4,
              height: height * 0.15,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineMedium,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined),
                    Expanded(
                      child: Text(
                        event.address ?? "No Address Found",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: textTheme.titleSmall!.copyWith(
                          color: AppTheme.backgroundDark,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
