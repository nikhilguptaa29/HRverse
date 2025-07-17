import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Utils/Widgets/checkCard.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ManagerDash extends StatefulWidget {
  const ManagerDash({super.key});

  @override
  State<ManagerDash> createState() => _ManagerDashState();
}

class _ManagerDashState extends State<ManagerDash> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context);
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    bool isFinished = false;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: 1.sw,
            decoration: BoxDecoration(),
            child: Column(
              children: [
                // Text(width.toString()),
                // Text(height.toString()),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 20.w),
                  child: Row(
                    children: [
                      Text(
                        "Hello, ${authProvider.name} 🤘",
                        style: GoogleFonts.merriweather(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 1.h),
                  child: Row(
                    children: [
                      Text(
                        "${authProvider.role}",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CheckCard(text: "Check-In"),
                    CheckCard(text: "Check-Out"),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 30.w, right: 30.w),
                  child: SwipeableButtonView(
                    onFinish: () {},
                    onWaitingProcess: () {
                      Future.delayed(Duration(seconds: 2));
                      setState(() {
                        isFinished = true;
                      });
                    },
                    activeColor: Colors.blue.shade400,
                    buttonWidget: Icon(Icons.arrow_forward),
                    buttonText: "Check-In",
                    isFinished: isFinished,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
                  child: SwipeableButtonView(
                    onFinish: () {},
                    onWaitingProcess: () {
                      Future.delayed(Duration(seconds: 2));
                      setState(() {
                        isFinished = true;
                      });
                    },
                    activeColor: Colors.blue.shade400,
                    buttonWidget: Icon(Icons.arrow_forward),
                    buttonText: "Check-In",
                    isFinished: isFinished,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0.h, right: 10.w, left: 5.w),
                  child: Container(
                    width: 0.98.sw,
                    height: 0.489.sh,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: Colors.indigo),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.r),
                                topRight: Radius.circular(25.r),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50.h,
                                  child: Marquee(
                                    text: "This is a scrolling text",
                                    style: GoogleFonts.meeraInimai(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    blankSpace: 40.0,
                                    velocity: 100.0,
                                    pauseAfterRound: Duration.zero,
                                    startPadding: 10.0,
                                    accelerationDuration: Duration.zero,
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration: Duration.zero,
                                    decelerationCurve: Curves.easeOut,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                  child: Marquee(
                                    text: "Scroller",
                                    style: GoogleFonts.meeraInimai(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    blankSpace: 40.0,
                                    velocity: 100.0,
                                    pauseAfterRound: Duration.zero,
                                    startPadding: 10.0,
                                    accelerationDuration: Duration.zero,
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration: Duration.zero,
                                    decelerationCurve: Curves.easeOut,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
