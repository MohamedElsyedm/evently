import 'package:evently/auth/login_screen.dart';
import 'package:evently/firebase_service.dart';
import 'package:evently/home_screen.dart';
import 'package:evently/ui_utils.dart';
import 'package:evently/widgets/default_elevated_button.dart';
import 'package:evently/widgets/default_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String routName = '/register screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Size screenSize = MediaQuery.sizeOf(context);

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
                hintText: 'Name',
                prefixIconImageName: 'name',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DefaultTextFormField(
                hintText: 'Email',
                prefixIconImageName: 'email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return 'Invalid Email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DefaultTextFormField(
                hintText: 'Password',
                prefixIconImageName: 'password',
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                isPassword: true,
              ),
              SizedBox(height: 24),
              DefaultElevatedButton(label: 'Register', onPressed: register),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already Have Account?', style: textTheme.titleMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(LoginScreen.routName);
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      FirebaseService.register(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          )
          .then((user) {
            UiUtils.showSuccessMessage('Registered Successfully');
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
            }
          })
          .catchError((error) {
            String? errorMessage;
            if (error is FirebaseAuthException) {
              //is => comparing type
              errorMessage = error.message;
            }
            UiUtils.showErrorMessage(errorMessage);
          });
    }
  }
}
