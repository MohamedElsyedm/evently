import 'package:evently/app_theme.dart';
import 'package:evently/auth/register_screen.dart';
import 'package:evently/firebase_service.dart';
import 'package:evently/home_screen.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/ui_utils.dart';
import 'package:evently/widgets/default_elevated_button.dart';
import 'package:evently/widgets/default_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routName = '/login screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final googleAuth = FirebaseService();
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Size screenSize = MediaQuery.sizeOf(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
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
                hintText: appLocalizations.email,
                prefixIconImageName: 'email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return appLocalizations.invalidEmail;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DefaultTextFormField(
                hintText: appLocalizations.password,
                prefixIconImageName: 'password',
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return appLocalizations.passError;
                  }
                  return null;
                },
                isPassword: true,
              ),
              SizedBox(height: 24),
              DefaultElevatedButton(
                label: appLocalizations.login,
                onPressed: login,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appLocalizations.dontHaveAccount,
                    style: textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(RegisterScreen.routName);
                    },
                    child: Text(appLocalizations.createAccount),
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
                      appLocalizations.or,
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
                onPressed: () => loginWithGoogle(),
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
                      appLocalizations.loginWithGoogle,
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
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      FirebaseService.login(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((user) {
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).updateCurrentUser(user);
            UiUtils.showSuccessMessage(appLocalizations.loginSuccessfully);
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
            }
          })
          .catchError((error) {
            print(
              'nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn$error nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn',
            );
            String? errorMessage;
            if (error is FirebaseAuthException) {
              //is => comparing type
              errorMessage = error.message;
            }
            UiUtils.showErrorMessage(errorMessage);
          });
    }
  }

  void loginWithGoogle() {
    googleAuth.signInWithGoogleAccount().then((user) {
      if (user == null) {
        UiUtils.showErrorMessage(appLocalizations.plsSelectUser);
        return;
      } else {
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).updateCurrentUser(user);
        UiUtils.showSuccessMessage(appLocalizations.loginSuccessfully);
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
        }
      }
    });
  }
}
