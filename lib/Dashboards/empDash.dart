import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Provider/timerProvider.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/checkCard.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class EmployeeDash extends StatefulWidget {
  const EmployeeDash({super.key});

  @override
  State<EmployeeDash> createState() => _EmployeeDashState();
}

class _EmployeeDashState extends State<EmployeeDash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<Authprovider>(context, listen: false);
      final attendanceProvider = Provider.of<AttendanceProvider>(
        context,
        listen: false,
      );
      final userId = authProvider.user!.uid;
      attendanceProvider.start(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    final Authservices authservices = Authservices();
    final timerProvider = Provider.of<Timerprovider>(context);
    final userId = authProvider.user!.uid;
    final userName = authservices.getUserName(userId);
    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    // Future<> checkIn()async{

    // }
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text("Employee")),
      // body: Center(child: Text('${authProvider.name}')),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: 1.sw,
              decoration: BoxDecoration(color: Colors.white),
            ),
            Container(
              width: 1.sw,
              height: 0.18.sh,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.indigo.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35.r),
                  bottomRight: Radius.circular(35.r),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.h,
                      left: 15.0.w,
                      right: 15.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, ${authProvider.name} 🤟",
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(radius: 25.r),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.h, left: 15.0.w),
                    child: Row(
                      children: [
                        Text(
                          "${authProvider.designation} ",
                          style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 140.h,
              child: SizedBox(
                width: 1.sw,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CheckCard(text: "Check In"),
                        CheckCard(text: "Check Out"),
                      ],
                    ),
                    Consumer<Timerprovider>(
                      builder: (ctx, timerProv, _) {
                        if (!timerProv.isStart) {
                          return ElevatedButton(
                            onPressed: () async {
                              bool check = await authProvider.biometricAuth();
                              if (check) {
                                attendanceProvider.checkIn(
                                  userId,
                                  await userName,
                                );
                                timerProv.setTimer();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Check-In Successfully"),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Unable to Check-In")),
                                );
                              }
                            },
                            child: Text("Check In"),
                          );
                        } else if (timerProv.showButton) {
                          return ElevatedButton(
                            onPressed: () async{
                              attendanceProvider.checkOut(userId, await userName);
                              timerProv.onCheckOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Check-out")),
                              );
                            },
                            child: Text("Check-Out"),
                          );
                          // return SizedBox(
                          //   width: 0.6.sw,
                          //   height: 0.07.sh,
                          //   child: SwipeableButtonView(
                          //     onFinish: () {},
                          //     onWaitingProcess: () {},
                          //     activeColor: Colors.blueAccent.shade400,
                          //     buttonWidget: Icon(Icons.login),
                          //     buttonText: "Check In",
                          //     buttontextstyle: TextStyle(
                          //       fontSize: 22.sp,
                          //       fontWeight: FontWeight.w400,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // );
                        } else {
                          return Container(
                            width: 0.5.sw,
                            height: 0.04.sh,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.2.w,
                              ),
                              color: Colors.red.shade600,
                            ),
                            child: Text(
                              "Time left:- ${timerProv.leftTime}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      },
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
