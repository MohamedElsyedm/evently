import 'package:evently/app_theme.dart';
import 'package:evently/tabs/profile/profile_header.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  List<Language> languages = [
    Language(code: 'en', name: 'English'),
    Language(code: 'ar', name: 'العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Language',
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              SizedBox(height: 16),
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
                  isExpanded: true,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Theme',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),

                  Switch(
                    inactiveTrackColor: AppTheme.grey,
                    activeTrackColor: AppTheme.primary,
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ],
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
