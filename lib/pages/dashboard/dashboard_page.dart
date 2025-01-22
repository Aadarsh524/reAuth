import 'package:flutter/material.dart';
import 'package:reauth/pages/dashboard/tabs/new_auth.dart';
import 'package:reauth/pages/dashboard/tabs/home_page.dart';
import 'package:reauth/pages/dashboard/tabs/notification_page.dart';
import 'package:reauth/pages/dashboard/tabs/security_page.dart';
import 'package:reauth/pages/dashboard/tabs/settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;
  final List<Widget> bottomTabs = [
    const HomePage(),
    const NewAuthPage(),
    const SecurityPage(),
    const NotificationPage(),
    const SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedIndex = 0;
    });
  }

  void onTapChangeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 125, 125, 125),
        onTap: onTapChangeIndex,
        backgroundColor: const Color.fromARGB(255, 43, 51, 63),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_outlined,
            ),
            activeIcon: Icon(
              Icons.add_box,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.security_outlined,
            ),
            activeIcon: Icon(
              Icons.security,
            ),
            label: 'Security',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_outlined,
            ),
            activeIcon: Icon(
              Icons.notifications,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
            ),
            activeIcon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: bottomTabs[selectedIndex],
      ),
    );
  }
}
