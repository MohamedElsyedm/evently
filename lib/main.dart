import 'package:evently/app_theme.dart';
import 'package:evently/auth/login_screen.dart';
import 'package:evently/auth/register_screen.dart';
import 'package:evently/create_event.dart';
import 'package:evently/edit_event.dart';
import 'package:evently/event_details.dart';
import 'package:evently/home_screen.dart';
import 'package:evently/onboarding/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(EventlyApp(onboardingComplete: onboardingComplete));
}

class EventlyApp extends StatelessWidget {
  bool onboardingComplete;
  EventlyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.routName: (_) => LoginScreen(),
        RegisterScreen.routName: (_) => RegisterScreen(),
        HomeScreen.routName: (_) => HomeScreen(),
        CreateEvent.routName: (_) => CreateEvent(),
        EventDetails.routName: (_) => EventDetails(),
        EditEvent.routName: (_) => EditEvent(),
        OnboardingScreen.routName: (_) => OnboardingScreen(),
      },

      initialRoute: onboardingComplete
          ? LoginScreen.routName
          : OnboardingScreen.routName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
