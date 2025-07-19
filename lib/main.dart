import 'package:evently/app_theme.dart';
import 'package:evently/auth/login_screen.dart';
import 'package:evently/auth/register_screen.dart';
import 'package:evently/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EventlyApp());
}

class EventlyApp extends StatelessWidget {
  const EventlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.routName: (_) => LoginScreen(),
        RegisterScreen.routName: (_) => RegisterScreen(),
        HomeScreen.routName: (_) => HomeScreen(),
      },
<<<<<<< HEAD
      initialRoute: HomeScreen.routName,
=======
      initialRoute: LoginScreen.routName,
>>>>>>> 53907f87442265dbb69c5c324bf18ac32e2a1fe1
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
