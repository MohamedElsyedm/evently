import 'package:evently/app_theme.dart';
import 'package:evently/models/category_model.dart';
import 'package:evently/providers/events_provider.dart';
import 'package:evently/tabs/home/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatefulWidget {
  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(left: 16, bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back ✨', style: textTheme.titleSmall),
            Text('User Name', style: textTheme.headlineSmall),
            SizedBox(height: 16),
            DefaultTabController(
              length: CategoryModel.categories.length + 1,
              child: TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                labelPadding: EdgeInsets.only(right: 10),
                onTap: (value) {
                  if (value != index) {
                    index = value;
                    CategoryModel? selectedCategory = index == 0
                        ? null
                        : CategoryModel.categories[index - 1];
                    //filter events
                    eventsProvider.filterEvents(selectedCategory);
                    setState(() {});
                  }
                },
                tabs: [
                  TabItem(
                    label: 'All',
                    icon: Icons.ac_unit_outlined,
                    isSelected: index == 0,
                    selectedForegroundColor: AppTheme.primary,
                    unSelectedForegroundColor: AppTheme.white,
                    selectedBackgroundColor: AppTheme.white,
                  ),
                  ...CategoryModel.categories.map(
                    (category) => TabItem(
                      icon: category.icon,
                      isSelected:
                          CategoryModel.categories.indexOf(category) + 1 ==
                          index,
                      label: category.name,
                      selectedForegroundColor: AppTheme.primary,
                      unSelectedForegroundColor: AppTheme.white,
                      selectedBackgroundColor: AppTheme.white,
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
}
