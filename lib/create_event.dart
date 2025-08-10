import 'package:evently/app_theme.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/models/category_model.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/settings_provider.dart';
import 'package:evently/tabs/home/tab_item.dart';
import 'package:evently/widgets/default_elevated_button.dart';
import 'package:evently/widgets/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  static const routName = '/create-event';

  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? dateValue;
  TimeOfDay? time;
  int currentIndex = 0;
  CategoryModel selectedCategory = CategoryModel.categories.first;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateFormat dateFormat = DateFormat('d/M/yyyy');

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.createEvent)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(16),
                child: Image.asset(
                  'assets/images/${selectedCategory.imageName}.png',
                  height: MediaQuery.sizeOf(context).height * 0.23,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            DefaultTabController(
              length: CategoryModel.categories.length,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                labelPadding: EdgeInsets.only(right: 10),
                padding: EdgeInsets.only(left: 16),
                tabs: CategoryModel.categories
                    .map(
                      (category) => TabItem(
                        label: category.name,
                        icon: category.icon,
                        isSelected:
                            currentIndex ==
                            CategoryModel.categories.indexOf(category),
                        selectedForegroundColor: settingsProvider.isDark
                            ? AppTheme.black
                            : AppTheme.white,
                        unSelectedForegroundColor: AppTheme.primary,
                        selectedBackgroundColor: AppTheme.primary,
                      ),
                    )
                    .toList(),
                onTap: (index) {
                  if (currentIndex == index) return;
                  currentIndex = index;
                  selectedCategory = CategoryModel.categories[currentIndex];
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.title,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)!.title,
                      style: textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: AppLocalizations.of(context)!.title,
                      prefixIconImageName: 'title',
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title can not be null';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.description,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)!.description,
                      style: textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: AppLocalizations.of(context)!.description,
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description can not be null';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/date.svg',
                          colorFilter: ColorFilter.mode(
                            settingsProvider.isDark
                                ? AppTheme.white
                                : AppTheme.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.eventDate,
                          style: textTheme.titleMedium,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                            );
                            if (date != null) {
                              selectedDate = date;
                              setState(() {});
                            }
                          },
                          child: Text(
                            selectedDate == null
                                ? AppLocalizations.of(context)!.chooseDate
                                : dateFormat.format(selectedDate!),
                            style: textTheme.titleMedium!.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/time.svg',
                          colorFilter: ColorFilter.mode(
                            settingsProvider.isDark
                                ? AppTheme.white
                                : AppTheme.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.eventTime,
                          style: textTheme.titleMedium,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              selectedTime = time;
                              setState(() {});
                            }
                          },
                          child: Text(
                            selectedTime == null
                                ? AppLocalizations.of(context)!.chooseTime
                                : selectedTime!.format(context),
                            style: textTheme.titleMedium!.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    DefaultElevatedButton(
                      label: AppLocalizations.of(context)!.createEvent,
                      onPressed: createEvent,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void createEvent() {
    if (formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null) {
      DateTime dateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      EventModel event = EventModel(
        category: selectedCategory,
        title: titleController.text,
        description: descriptionController.text,
        dateTime: dateTime,
      );
      Provider.of<EventsProvider>(context, listen: false).addEvent(event);
      Navigator.of(context).pop();
      Provider.of<EventsProvider>(context, listen: false).addEvent(event);
      Navigator.of(context).pop();
    }
  }
}
