import 'package:evently/firebase_service.dart';
import 'package:evently/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentUser;

  void updateCurrentUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }

  bool checkIsFavoriteEvent(String eventId) {
    return currentUser!.favoriteEventIds.contains(eventId);
  }

  void addEventToFavorites(String eventId) {
    FirebaseService.addEventToFavorite(eventId);
    currentUser!.favoriteEventIds.add(eventId);
    notifyListeners();
  }

  void removeEventFromFavorites(String eventId) {
    FirebaseService.removeEventFromFavorite(eventId);
    currentUser!.favoriteEventIds.remove(eventId);
    notifyListeners();
  }
}
