import 'package:evently/app_theme.dart';
import 'package:evently/onboarding/onboarding_model.dart';
import 'package:evently/onboarding/onboarding_service.dart';
import 'package:flutter/material.dart';

class OnboardingItem extends StatelessWidget {
  int index;
  OnboardingItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<OnboardingModel> itemsList = OnboardingService.onboardingList;
    TextTheme textTheme = Theme.of(context).textTheme;
    Size screenSize = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/onboarding_${itemsList[index].imgName}.png',
          width: screenSize.width,
          height: screenSize.height * 0.35,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.03),
          child: Text(
            itemsList[index].title,
            style: textTheme.titleLarge!.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(itemsList[index].description, style: textTheme.titleMedium),
      ],
    );
  }
}
