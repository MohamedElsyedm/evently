import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/models/category_model.dart';

class EventModel {
  String id;
  CategoryModel category;
  String title;
  String description;
  DateTime dateTime;
  double? long;
  double? lat;
  String? address;

  EventModel({
    this.id = '',
    required this.category,
    required this.title,
    required this.description,
    required this.dateTime,
    this.lat,
    this.long,
    this.address,
  });

  EventModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        category: CategoryModel.categories.firstWhere(
          (category) => category.id == json['categoryId'],
        ),
        title: json['title'],
        description: json['description'],
        dateTime: (json['timestamp'] as Timestamp).toDate(),
        lat: json['lat'],
        long: json['long'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': category.id,
    'title': title,
    'description': description,
    'timestamp': Timestamp.fromDate(dateTime),
    'lat': lat,
    'long': long,
    'address': address,
  };
}
