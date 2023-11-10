import 'package:flutter/material.dart';
import 'package:reauth/pages/dashboard/editprovider_page.dart';
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
  final List<Widget> bottomTabs = const [
    HomePage(),
    EditProviderPage(),
    SecurityPage(),
    NotificationPage(),
    SettingsPage()
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 43, 51, 63),
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: onTapChangeIndex,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.home_outlined,
              color: Color.fromARGB(255, 125, 125, 125),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.add_box,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.add_box_outlined,
              color: Color.fromARGB(255, 125, 125, 125),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.health_and_safety,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.health_and_safety_outlined,
              color: Color.fromARGB(255, 125, 125, 125),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.notifications_outlined,
              color: Color.fromARGB(255, 125, 125, 125),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.settings_outlined,
              color: Color.fromARGB(255, 125, 125, 125),
            ),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        child: bottomTabs[selectedIndex],
      ),
    );
  }
}
