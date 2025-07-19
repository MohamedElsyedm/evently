import 'package:evently/app_theme.dart';
import 'package:evently/auth/register_screen.dart';
import 'package:evently/widgets/default_elevated_button.dart';
import 'package:evently/widgets/default_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routName = '/login screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
              height: screenSize.height * 0.2,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 24),
            DefaultTextFormField(
              hintText: 'Email',
              prefixIconImageName: 'email',
              controller: emailController,
            ),
            SizedBox(height: 16),
            DefaultTextFormField(
              hintText: 'Password',
              prefixIconImageName: 'password',
              controller: emailController,
            ),
            SizedBox(height: 24),
            DefaultElevatedButton(label: 'Login', onPreessed: login),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don’t Have Account?', style: textTheme.titleMedium),
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(RegisterScreen.routName);
                  },
                  child: Text('Create Account'),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1,
                  width: screenSize.width * 0.35,
                  color: AppTheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Or',
                    style: textTheme.titleMedium!.copyWith(
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: screenSize.width * 0.35,
                  color: AppTheme.primary,
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.white,

                fixedSize: Size(screenSize.width, 57),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/icons/google_icon.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    'Login With Google',
                    style: textTheme.titleLarge!.copyWith(
                      color: AppTheme.primary,
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

  void login() {}
}
