import 'package:evently/app_theme.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/maps_functions/location_services.dart';
import 'package:evently/models/category_model.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/location_provider.dart';
import 'package:evently/providers/settings_provider.dart';
import 'package:evently/tabs/home/tab_item.dart';
import 'package:evently/widgets/default_elevated_button.dart';
import 'package:evently/widgets/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  LatLng? locationLatLang;
  String? address;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.userLocation ??
        locationProvider.getCurrentLocation(context);

    TextTheme textTheme = Theme.of(context).textTheme;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.createEvent)),
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
                    Text(appLocalizations.title, style: textTheme.titleMedium),
                    SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: appLocalizations.title,
                      prefixIconImageName: 'title',
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalizations.titleError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      appLocalizations.description,
                      style: textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: appLocalizations.description,
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalizations.descriptionError;
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
                          appLocalizations.eventDate,
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
                                ? appLocalizations.chooseDate
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
                          appLocalizations.eventTime,
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
                                ? appLocalizations.chooseTime
                                : selectedTime!.format(context),
                            style: textTheme.titleMedium!.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primary),
                      ),
                      child: InkWell(
                        onTap: () async {
                          LatLng? currentLocationLatLang =
                              await LocationServices.pickLocation(context);
                          if (currentLocationLatLang != null) {
                            locationLatLang = currentLocationLatLang;
                            address = await LocationServices.getLocationAddress(
                              currentLocationLatLang,
                            );
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.my_location_rounded,
                                size: 24,
                                color: AppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                address != null
                                    ? address!
                                    : appLocalizations.chooseLocation,
                                style: textTheme.titleMedium!.copyWith(
                                  color: AppTheme.primary,
                                ),
                                maxLines: null,
                              ),
                            ),

                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 24,
                              color: AppTheme.primary,
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    DefaultElevatedButton(
                      label: appLocalizations.createEvent,
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
        address: address,
        long: locationLatLang!.longitude,
        lat: locationLatLang!.latitude,
      );
      Provider.of<EventsProvider>(context, listen: false).addEvent(event);
      Navigator.of(context).pop();
    }
  }
}
