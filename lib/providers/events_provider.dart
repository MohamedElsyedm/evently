import 'package:evently/firebase_service.dart';
import 'package:evently/models/category_model.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/ui_utils.dart';
import 'package:flutter/material.dart';

//inheritance be in extends only
// but with mixin be to use functions from class without inherit from it
class EventsProvider with ChangeNotifier {
  List<EventModel> allEvents = [];
  List<EventModel> displayedEvents = [];
  List<EventModel> favoriteEvents = [];

  Future<void> getEvents() async {
    allEvents = await FirebaseService.getEvents();
    displayedEvents = allEvents;
    notifyListeners();
  }

  void filterEvents(CategoryModel? category) {
    if (category == null) {
      displayedEvents = allEvents;
    } else {
      displayedEvents = allEvents
          .where((event) => event.category == category)
          .toList();
    }
    notifyListeners();
  }

  void filterFavoriteEvents(List<String> favoriteIds) {
    favoriteEvents = allEvents
        .where((event) => favoriteIds.contains(event.id))
        .toList();
    notifyListeners();
  }

  void editEvent(EventModel updatedEvent) {
    FirebaseService.editEvent(updatedEvent)
        .then((_) {
          UiUtils.showSuccessMessage('Event edited successfully');
        })
        .catchError((_) {
          UiUtils.showErrorMessage('Event failed to create');
        });
    int index = displayedEvents.indexWhere(
      (event) => event.id == updatedEvent.id,
    );
    displayedEvents[index] = updatedEvent;
    getEvents();
    notifyListeners();
  }

  void deleteEvent(EventModel event) {
    FirebaseService.deleteEvent(event)
        .then((_) {
          UiUtils.showSuccessMessage('Event deleted successfully');
        })
        .catchError((_) {
          UiUtils.showErrorMessage('Something went wrong');
        });
    displayedEvents.remove(event);
    notifyListeners();
  }

  void addEvent(EventModel newEvent) {
    FirebaseService.createEvent(newEvent)
        .then((_) {
          UiUtils.showSuccessMessage('Event created successfully');
        })
        .catchError((_) {
          UiUtils.showErrorMessage('Failed to create event');
        });
    displayedEvents.add(newEvent);
    getEvents();
    notifyListeners();
  }
}
