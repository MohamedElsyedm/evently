import 'package:evently/app_theme.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Image.asset(
              'assets/images/user_image.png',
              height: MediaQuery.sizeOf(context).height * 0.15,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.currentUser!.name,
                    style: textTheme.headlineSmall,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userProvider.currentUser!.email,
                    style: textTheme.titleMedium!.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
