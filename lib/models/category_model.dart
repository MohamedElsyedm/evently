import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryModel {
  String id;
  String name;
  IconData icon;
  String imageName;

  CategoryModel({
    required this.id,
    required this.icon,
    required this.imageName,
    required this.name,
  });

  static List<CategoryModel> categories = [
    CategoryModel(
      id: '1',
      icon: Icons.sports_baseball_outlined,
      imageName: 'sport',
      name: 'Sport',
    ),
    CategoryModel(
      id: '2',
      icon: Icons.cake_outlined,
      imageName: 'birthday',
      name: 'Birthday',
    ),
    CategoryModel(
      id: '3',
      icon: Icons.games_outlined,
      imageName: 'gaming',
      name: 'Gaming',
    ),
    CategoryModel(
      id: '4',
      icon: Icons.airline_seat_recline_extra_rounded,
      imageName: 'holiday',
      name: 'Holiday',
    ),
    CategoryModel(
      id: '5',
      icon: Icons.groups_2_outlined,
      imageName: 'meeting',
      name: 'Meeting',
    ),
    CategoryModel(
      id: '6',
      icon: Icons.handyman_outlined,
      imageName: 'workshop',
      name: 'Workshop',
    ),
    CategoryModel(
      id: '7',
      icon: Icons.work_outline_outlined,
      imageName: 'exhibition',
      name: 'Exhibition',
    ),
    CategoryModel(
      id: '8',
      icon: Icons.fastfood_outlined,
      imageName: 'eating',
      name: 'Eating',
    ),
    CategoryModel(
      id: '9',
      icon: Icons.menu_book_rounded,
      imageName: 'bookclub',
      name: 'bookCub',
    ),
  ];
}
