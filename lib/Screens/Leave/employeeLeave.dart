import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/leaveProvider.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/Leave%20Request/leaveRequest.dart';
import 'package:provider/provider.dart';

class EmployeeLeave extends StatefulWidget {
  const EmployeeLeave({super.key});

  @override
  State<EmployeeLeave> createState() => _EmployeeLeaveState();
}

class _EmployeeLeaveState extends State<EmployeeLeave>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> tabs = [Tab(text: "Leave"), Tab(text: "OD Tour Mispunch")];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(color: Colors.grey.shade200),
            ),
            Container(
              width: width,
              height: height / 9.5,
              decoration: BoxDecoration(
                color: Colors.indigo.shade300,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Leaves",
                    style: GoogleFonts.merriweather(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: height / 9,
              left: 2,
              right: 2,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border.all(color: Colors.black26, width: 2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TabBar(
                              labelStyle: GoogleFonts.merriweather(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              tabs: tabs,
                              // dividerColor: Colors.black,
                              controller: _tabController,
                              labelColor: Colors.white,
                              isScrollable: true,
                              indicatorPadding: EdgeInsets.only(left: 10),
                              tabAlignment: TabAlignment.center,
                              // labelPadding: EdgeInsets.only(top: 10, left: 15),
                              indicator: BoxDecoration(),
                              indicatorColor: Colors.black,
                              // unselectedLabelColor: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          LeaveRequest(),
                          Container(
                            decoration: BoxDecoration(color: Colors.yellow),
                            // decoration: BoxDecoration(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
