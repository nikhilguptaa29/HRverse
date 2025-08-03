import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Provider/timerProvider.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/checkCard.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      // if (userId != null) {
      //   try {
      //     Provider.of<AttendanceProvider>(
      //       context,
      //       listen: false,
      //     ).fetchLeaveBalance(userId);
      //     // Provider.of<AttendanceProvider>(context).leaveModel;
      //   } catch (e) {
      //     throw Exception("Unable to fetch leave balance: $e");
      //   }
      // }
      attendanceProvider.start(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    final Authservices _authServices = Authservices();
    final timerProvider = Provider.of<Timerprovider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userName = authProvider.name;
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    // final leaveBalance = Provider.of<AttendanceProvider>(context).leaveModel;
    // if (leaveBalance == null) {
    //   return Center(child: CircularProgressIndicator());
    // }

    // int casual = int.tryParse(leaveBalance.casualLeaves) ?? 0;
    // int paid = int.tryParse(leaveBalance.paidLeave) ?? 0;
    // int sick = leaveBalance.leavesCount ?? 0;
    // print(casual);
    // print(paid);
    // print(sick);
    // List<List<dynamic>> leaveChart = [
    //   [casual, "Casual Leaves", const Color.fromARGB(155, 10, 25, 40)],
    //   [paid, "Paid Leaves", const Color.fromARGB(255, 150, 50, 140)],
    //   [sick, "Sick Leaves", const Color.fromARGB(155, 1, 125, 90)],
    // ];

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
              height: 0.16.sh,
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
              child: Container(
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
                                await attendanceProvider.checkIn(
                                  userId,
                                  userName!,
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
                            onPressed: () async {
                              await attendanceProvider.checkOut(
                                userId,
                                userName!,
                              );
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
                                color: Colors.red,
                                width: 1.2.w,
                              ),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              "Time left:- ${timerProv.leftTime}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    // SfCircularChart(
                    //   annotations: <CircularChartAnnotation>[
                    //     CircularChartAnnotation(
                    //       widget: Container(
                    //         child: Text(
                    //           "${sick}",
                    //           style: GoogleFonts.merriweather(
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.w800,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    //   series: [
                    //     DoughnutSeries(
                    //       dataSource: leaveChart,
                    //       innerRadius: '55%',
                    //       cornerStyle: CornerStyle.bothFlat,
                    //       enableTooltip: true,
                    //       yValueMapper: (data, _) => data[0],
                    //       xValueMapper: (data, _) => data[1],
                    //       dataLabelMapper: (data, _) => data[0].toString(),
                    //       dataLabelSettings: DataLabelSettings(
                    //         isVisible: true,
                    //         textStyle: GoogleFonts.merriweather(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w500,
                    //           color: Colors.black,
                    //         ),
                    //         labelPosition: ChartDataLabelPosition.outside,
                    //       ),
                    //       explode: true,
                    //       radius: '50%',
                    //       pointColorMapper: (data, _) => data[2],
                    //     ),
                    //   ],
                    //   legend: Legend(
                    //     isVisible: true,
                    //     position: LegendPosition.right,
                    //     orientation: LegendItemOrientation.vertical,
                    //     textStyle: GoogleFonts.merriweather(fontSize: 14),
                    //   ),
                    // ),
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
