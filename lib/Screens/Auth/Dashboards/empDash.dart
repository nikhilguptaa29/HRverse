import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Utils/Widgets/checkCard.dart';
import 'package:provider/provider.dart';

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

      attendanceProvider.fetchDailyAttendance(
        authProvider.user!.uid,
        authProvider.name!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
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
        child: SingleChildScrollView(
          child: Row(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 25.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hello, ${authProvider.name} 🤟",
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CircleAvatar(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2, left: 25.0),
                      child: Row(
                        children: [
                          Text(
                            "${authProvider.role} ",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CheckCard(text: "Check In"),
                                CheckCard(text: "Check Out"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
  try {
    bool result = await attendanceProvider.checkIn(
      authProvider.user!.uid,
      authProvider.name!,
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Check In successful")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ You are not in the office location")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🔥 Error: ${e.toString()}")),
    );
  }
},
                          child: Text("Check In"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
