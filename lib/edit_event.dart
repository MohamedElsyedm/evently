import 'package:evently/app_theme.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/maps_functions/location_services.dart';
import 'package:evently/models/category_model.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/location_provider.dart';
import 'package:evently/tabs/home/tab_item.dart';
import 'package:evently/ui_utils.dart';
import 'package:evently/widgets/default_elevated_button.dart';
import 'package:evently/widgets/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEvent extends StatefulWidget {
  static const String routName = '/edit event';
  const EditEvent({super.key});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
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
  EventModel? currentEvent;
  LatLng? locationLatLang;
  String? address;
  AppLocalizations? appLocalizations;

  void declaration(BuildContext ctx) {
    currentEvent = ModalRoute.of(context)!.settings.arguments as EventModel;
    titleController.text = currentEvent!.title;
    descriptionController.text = currentEvent!.description;
    currentIndex = CategoryModel.categories.indexOf(currentEvent!.category);
    selectedCategory = currentEvent!.category;
    selectedDate = currentEvent!.dateTime;
    selectedTime = TimeOfDay.fromDateTime(currentEvent!.dateTime);
    address = currentEvent?.address ?? 'El Sharkia, Egypt';
    locationLatLang = LatLng(
      currentEvent?.lat ?? 31.56415324,
      currentEvent?.long ?? 32.546153132,
    );
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;
    if (currentEvent == null) {
      declaration(context);
    }
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.userLocation ??
        locationProvider.getCurrentLocation(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editEvent)),
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
                        selectedForegroundColor: AppTheme.white,
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
                    SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: AppLocalizations.of(context)!.title,
                      prefixIconImageName: 'title',
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.titleError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
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
                          return AppLocalizations.of(context)!.descriptionError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/date.svg'),
                        SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.eventDate,
                          style: textTheme.titleMedium!.copyWith(
                            color: AppTheme.primary,
                          ),
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
                        SvgPicture.asset('assets/icons/time.svg'),
                        SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.eventTime,
                          style: textTheme.titleMedium!.copyWith(
                            color: AppTheme.primary,
                          ),
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
                                    : appLocalizations!.chooseLocation,
                                style: textTheme.titleMedium!.copyWith(
                                  color: AppTheme.primary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                      label: AppLocalizations.of(context)!.editEvent,
                      onPressed: editEvent,
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

  void editEvent() {
    UiUtils.showLoading(
      context,
      canPop: true,
      title: Text(appLocalizations!.editEvent),
      content: Center(child: Text(appLocalizations!.editEventMessage)),
      buttonText: appLocalizations!.editEvent,
      onTap: () {
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
            id: currentEvent!.id,
            category: selectedCategory,
            title: titleController.text,
            description: descriptionController.text,
            dateTime: dateTime,
            address: address,
            lat: locationLatLang?.latitude ?? 31.54523526,
            long: locationLatLang?.longitude ?? 32.456461557,
          );
          Provider.of<EventsProvider>(context, listen: false).editEvent(event);
        }
        UiUtils.hideLoading(context);
        Navigator.of(context).pop();
      },
    );
  }
}
