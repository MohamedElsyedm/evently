import 'package:evently/app_theme.dart';
import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  String label;
  IconData icon;
  bool isSelected;
  Color selectedForegroundColor;
  Color unSelectedForegroundColor;
  Color selectedBackgroundColor;

  TabItem({
<<<<<<< HEAD
    super.key,
=======
>>>>>>> 6b1f7a44b53913584c5c27f5cc6971947359a248
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedForegroundColor,
    required this.unSelectedForegroundColor,
    required this.selectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? selectedBackgroundColor : Colors.transparent,
        borderRadius: BorderRadius.circular(46),
        border: isSelected ? null : Border.all(color: AppTheme.white),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected
                ? selectedForegroundColor
                : unSelectedForegroundColor,
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: isSelected
                  ? selectedForegroundColor
                  : unSelectedForegroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
