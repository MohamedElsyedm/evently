import 'package:evently/auth/login_screen.dart';
import 'package:evently/onboarding/dot_indicator.dart';
import 'package:evently/onboarding/onboarding_item.dart';
import 'package:evently/onboarding/onboarding_service.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routName = '/onboarding_screen';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: screenSize.width * 0.15,
              fit: BoxFit.fill,
            ),
            SizedBox(height: screenSize.height * 0.03),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: OnboardingService.onboardingList.length,
                itemBuilder: (_, int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OnboardingItem(index: index),
                ),
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (pageIndex >= 1) {
                        _controller.animateToPage(
                          pageIndex - 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                        print(pageIndex);
                      }
                    },
                    icon: Icon(Icons.arrow_back_outlined, size: 24),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      DotIndicator(isActive: pageIndex == 0),
                      DotIndicator(isActive: pageIndex == 1),
                      DotIndicator(isActive: pageIndex == 2),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      if (pageIndex <= 1) {
                        _controller.animateToPage(
                          pageIndex + 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                        print(pageIndex);
                      }
                      if (pageIndex == 2) {
                        Navigator.pushNamed(context, LoginScreen.routName);
                        OnboardingService.onboardingComplete();
                      }
                    },
                    icon: Icon(Icons.arrow_forward_outlined, size: 24),
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
