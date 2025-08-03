import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        Provider.of<AttendanceProvider>(
          context,
          listen: false,
        ).fetchLeaveBalance(userId);
        // Provider.of<AttendanceProvider>(context).leaveModel;
      } catch (e) {
        throw Exception("Unable to fetch leave balance: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveBalance = Provider.of<AttendanceProvider>(context).leaveModel;
    if (leaveBalance == null) {
      return Center(child: CircularProgressIndicator());
    }

    int casual = int.tryParse(leaveBalance.casualLeaves) ?? 0;
    int paid = int.tryParse(leaveBalance.paidLeave) ?? 0;
    int sick = leaveBalance.leavesCount ?? 0;
    print(casual);
    print(paid);
    print(sick);
    List<List<dynamic>> leaveChart = [
      [casual, "Casual Leaves", const Color.fromARGB(155, 10, 25, 40)],
      [paid, "Paid Leaves", const Color.fromARGB(255, 150, 50, 140)],
      [sick, "Sick Leaves", const Color.fromARGB(155, 1, 125, 90)],
    ];
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: SfCircularChart(
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(widget: Container(
                      child: Text("${sick}",style: GoogleFonts.merriweather(fontSize: 15,fontWeight: FontWeight.w800),),
                    ))
                  ],
                  series: [
                    DoughnutSeries(
                      dataSource: leaveChart,
                      innerRadius: '55%',
                      cornerStyle: CornerStyle.bothFlat,
                      enableTooltip: true,
                      yValueMapper: (data, _) => data[0],
                      xValueMapper: (data, _) => data[1],
                      dataLabelMapper: (data, _) => data[0].toString(),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: GoogleFonts.merriweather(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        labelPosition: ChartDataLabelPosition.outside,
                      ),
                      explode: true,
                      radius: '60%',
                      explodeOffset: '15%',
                      legendIconType: LegendIconType.seriesType,
                      pointColorMapper: (data, _) => data[2],
                    ),
                  ],
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.right,
                  orientation: LegendItemOrientation.vertical,
                  textStyle: GoogleFonts.merriweather(fontSize: 14)
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
