import 'package:evently/app_theme.dart';
import 'package:evently/auth/login_screen.dart';
import 'package:evently/auth/register_screen.dart';
import 'package:evently/create_event.dart';
import 'package:evently/edit_event.dart';
import 'package:evently/event_details.dart';
import 'package:evently/fcm_services.dart';
import 'package:evently/home_screen.dart';
import 'package:evently/onboarding/onboarding_screen.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/location_provider.dart';
import 'package:evently/providers/settings_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/maps_functions/location_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FCMServices.setupFlutterNotifications();
  FCMServices.showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMServices.printDeviceToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FCMServices.setupFlutterNotifications();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  Provider.debugCheckInvalidValueType = null;

  ///cascade operator (..) separate operation or action (2 * 1)
  ///one dot return
  runApp(
    MultiProvider(
      //called one time in create
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EventsProvider()..getEvents()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: EventlyApp(onboardingComplete: onboardingComplete),
    ),
  );
}

class EventlyApp extends StatefulWidget {
  bool onboardingComplete;
  EventlyApp({super.key, required this.onboardingComplete});

  @override
  State<EventlyApp> createState() => _EventlyAppState();
}

class _EventlyAppState extends State<EventlyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(FCMServices.showFlutterNotification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

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
        LocationPicker.routName: (_) => LocationPicker(),
      },

      initialRoute: widget.onboardingComplete
          ? LoginScreen.routName
          : OnboardingScreen.routName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsProvider.themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settingsProvider.languageCode),
    );
  }
}
