import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Screens/HR%20Dashboard/Employee%20Detail%20Screens/addEmployee.dart';
import 'package:hrverse/Screens/HR%20Dashboard/Employee%20Detail%20Screens/deleteEmployee.dart';
import 'package:hrverse/Screens/HR%20Dashboard/Employee%20Detail%20Screens/emloyeeDetails.dart';
import 'package:hrverse/Screens/HR%20Dashboard/Dashboard%20Screens/mainDashboard.dart';
import 'package:hrverse/Screens/HR%20Dashboard/Dashboard%20Screens/reportDetail.dart';
import 'package:hrverse/Screens/HR%20Dashboard/Employee%20Detail%20Screens/updateEmployee.dart';

class HrDash extends StatefulWidget {
  const HrDash({super.key});

  @override
  State<HrDash> createState() => _HrDashState();
}

class _HrDashState extends State<HrDash> {
  int index = 0;

  //set the expansion of Navigation rail

  bool isExpanded = false;
  int? isEmployee;

  final List<Widget> pages = [MainDash(), SizedBox(), ReportDetail()];
  final List<Widget> employeePages = [
    AddEmployee(),
    UpdateEmployee(),
    DeleteEmployee(),
  ];

  void _toggleRail() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double navItemHeight = 70.0;
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: isExpanded,
              // leading: Padding(
              //   padding: EdgeInsets.only(top: 5, bottom: 15),
              //   child: Image.asset('Assets/Images/logo.png', width: 120),
              // ),
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text(
                    "Dashboard",
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  indicatorColor: Colors.transparent,
                  selectedIcon: Icon(Icons.home),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text(
                    "Employee",
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedIcon: Icon(Icons.person),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.file_copy),
                  label: Text(
                    "Report",
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  indicatorColor: Colors.pink.shade300,
                  selectedIcon: Icon(Icons.dashboard),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_month),
                  label: Text(
                    "Leaves",
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  indicatorColor: Colors.pink.shade300,
                  selectedIcon: Icon(Icons.dashboard),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text(
                    "Settings",
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              selectedIndex: index,
              onDestinationSelected: (value) {
                setState(() {
                  index = value;
                  isEmployee = null;
                });
              },
              backgroundColor: Colors.blue,
              unselectedIconTheme: IconThemeData(
                color: Colors.white54,
                opacity: 1,
              ),
              selectedIconTheme: IconThemeData(color: Colors.black),
              // labelType: NavigationRailLabelType.all,
            ),
            VerticalDivider(thickness: 0.1, width: 0.5),
            if (index == 1) ...[
              NavigationRail(
                extended: isExpanded,
                unselectedIconTheme: IconThemeData(
                  color: Colors.white54,
                  opacity: 1,
                ),
                backgroundColor: Colors.blue.shade300,
                destinations: [
                  NavigationRailDestination(
                    // selectedIcon: Icon(Icons.person_add_alt_1_outlined),
                    icon: Icon(Icons.person_add_alt_1_rounded),
                    label: Text(
                      'Add Employee',
                      style: GoogleFonts.merriweather(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.edit),
                    label: Text(
                      'Update Employee',
                      style: GoogleFonts.merriweather(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_remove_alt_1_sharp),
                    label: Text(
                      'Remove Employee',
                      style: GoogleFonts.merriweather(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_add_alt_1_rounded),
                    label: Text(
                      'Add Employee',
                      style: GoogleFonts.merriweather(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                selectedIndex: isEmployee,
                onDestinationSelected: (value) {
                  setState(() {
                    isEmployee = value;
                  });
                },
              ),
            ],

            Container(
              decoration: BoxDecoration(),
              width: width / 45,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: _toggleRail,
                      icon:
                          isExpanded
                              ? Icon(Icons.arrow_back)
                              : Icon(Icons.menu),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  index == 1
                      ? (isEmployee == null
                          ? SizedBox()
                          : employeePages[isEmployee!])
                      : pages[index],
            ),
          ],
        ),
      ),
    );
  }
}
