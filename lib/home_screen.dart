import 'package:evently/app_theme.dart';
import 'package:evently/nav_bar_icon.dart';
import 'package:evently/tabs/home/home_tab.dart';
import 'package:evently/tabs/love/love_tab.dart';
import 'package:evently/tabs/map/map_tab.dart';
import 'package:evently/tabs/profile/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = '/homeScreen';

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  List<Widget> tabs = [HomeTab(), MapTab(), LoveTab(), ProfileTab()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: AppTheme.primary,
        elevation: 0,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'home'),
              activeIcon: NavBarIcon(imageName: 'selected_home'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'map'),
              activeIcon: NavBarIcon(imageName: 'selected_map'),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'love'),
              activeIcon: NavBarIcon(imageName: 'selected_love'),
              label: 'Love',
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'profile'),
              activeIcon: NavBarIcon(imageName: 'selected_profile'),
              label: 'Profile',
            ),
          ],
          currentIndex: index,
          onTap: (value) {
            if (index != value) {
              index = value;
              setState(() {});
            }
          },
        ),
      ),
      body: tabs[index],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
