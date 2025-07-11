import 'package:flutter/material.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Screens/Auth/Dashboards/empDash.dart';
import 'package:hrverse/Screens/Auth/Dashboards/managerDash.dart';
import 'package:hrverse/Screens/Leave/employeeLeave.dart';
import 'package:hrverse/Screens/Leave/managerLeave.dart';
// import 'package:hrverse/Screens/Leave/reportsPage.dart';
import 'package:hrverse/Screens/profilePage.dart';
import 'package:hrverse/Screens/reportsPage.dart';
import 'package:hrverse/Screens/settingsPage.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final roles = Provider.of<Authprovider>(context, listen: false).role;

    final dashboard = roles == 'Employee' ? EmployeeDash() : ManagerDash();
    final leave = roles == 'Employee' ? EmployeeLeave() : ManagerLeave();

    final List<Widget> screens = [
      dashboard,
      leave,
      ReportsPage(),
      SettingsPage(),
      ProfilePage(),
    ];

    final List<SalomonBottomBarItem> items = [
      SalomonBottomBarItem(
        icon: Icon(Icons.dashboard),
        title: Text("Dashboard"),
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.trip_origin),
        title: Text("Leaves"),
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.description),
        title: Text("Reports"),
      ),
      SalomonBottomBarItem(icon: Icon(Icons.settings), title: Text("Settings")),
      SalomonBottomBarItem(icon: Icon(Icons.person), title: Text("Profile")),
    ];
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SalomonBottomBar(
          items: items,
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value; 
            });
          },  
        ),
      ),
    );
  }
}
