import 'package:evently/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Image.asset(
              'assets/images/eating.png',
              width: MediaQuery.sizeOf(context).width * 0.30,
              height: MediaQuery.sizeOf(context).height * 0.12,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User Name', style: textTheme.headlineSmall),
                SizedBox(height: 10),
                Text(
                  'User Email@gmail.com',
                  style: textTheme.titleMedium!.copyWith(color: AppTheme.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
