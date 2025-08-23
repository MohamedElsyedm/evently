import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String id;
  String name;
  String email;
  List<String> favoriteEventIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.favoriteEventIds,
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        favoriteEventIds: (json['favoriteEventIds'] as List).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'favoriteEventIds': favoriteEventIds,
  };

  factory UserModel.fromFirebaseUser(User? user) {
    if (user == null) {
      return UserModel(id: '', name: '', email: '', favoriteEventIds: []);
    }
    return UserModel(
      id: user.uid,
      email: user.email.toString(),
      name: user.displayName.toString(),
      favoriteEventIds: [],
    );
  }
}
