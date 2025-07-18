import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              width: 1.sw,
              height: 1.sh,
              decoration: BoxDecoration(color: Colors.white24),
            ),
            Container(
              width: 1.sw,
              height: 0.1.sh,
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Leaves",
                    style: GoogleFonts.merriweather(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.115.sh,
              left: 5.w,
              right: 5.w,
              child: Container(
                width: 1.sw,
                height: 1.sh,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border.all(color: Colors.black26, width: 1.2.w),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade200,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TabBar(
                              dividerColor: Colors.transparent,
                              dividerHeight: 5.h,
                              labelStyle: GoogleFonts.merriweather(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              tabs: tabs,
                              // dividerColor: Colors.black,
                              controller: _tabController,
                              labelColor: Colors.white,
                              isScrollable: true,
                              indicatorPadding: EdgeInsets.only(left: 5.w),
                              tabAlignment: TabAlignment.center,
                              // labelPadding: EdgeInsets.only(top: 10, left: 15),
                              indicator: BoxDecoration(
                              ),
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
