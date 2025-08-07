import 'package:evently/app_theme.dart';
import 'package:evently/auth/login_screen.dart';
import 'package:evently/firebase_service.dart';
import 'package:evently/providers/settings_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/tabs/profile/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  List<Language> languages = [
    Language(code: 'en', name: 'English'),
    Language(code: 'ar', name: 'العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(),
        SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Language',
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButton(
                        value: 'en',
                        items: languages
                            .map(
                              (Language) => DropdownMenuItem(
                                value: Language.code,
                                child: Text(
                                  Language.name,
                                  style: textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {},
                        borderRadius: BorderRadius.circular(16),
                        underline: SizedBox(),
                        iconEnabledColor: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Theme',
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    ),
                    Switch(
                      activeTrackColor: AppTheme.primary,

                      value: settingsProvider.isDark,
                      onChanged: (isDark) {
                        settingsProvider.changeTheme(
                          isDark ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    FirebaseService.logout().then((_) {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routName)
                          .then(
                            (_) => Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).updateCurrentUser(null),
                          );
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      color: AppTheme.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 24, color: AppTheme.white),
                        SizedBox(width: 8),
                        Text('Logout', style: textTheme.titleLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Language {
  String code;
  String name;

  Language({required this.code, required this.name});
}
