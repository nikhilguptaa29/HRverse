import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  bool isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: 1.sw,
              height: 1.sh,
              decoration: BoxDecoration(color: Colors.white),
            ),
            Container(
              width: 1.sw,
              height: 0.18.sh,
              decoration: BoxDecoration(color: Colors.blue.shade800),
              child: Padding(
                padding: EdgeInsets.only(left: 15.0.w),
                child: Row(
                  children: [
                    CircleAvatar(radius: 40.r),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${authProvider.name}",
                              style: GoogleFonts.merriweather(
                                fontSize: 28.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${authProvider.designation}",
                              style: GoogleFonts.merriweather(
                                fontSize: 18.sp,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w700,
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
            Positioned(
              top: 0.19.sh,
              child: SingleChildScrollView(
                child: Container(
                  width: 1.sw,
                  height: 0.8.sh,
                  // height: 200.h,
                  decoration: BoxDecoration(),
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Edit Profile"),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Edit Profile"),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Edit Profile"),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                      SwitchListTile(
                        value: isBiometricEnabled,
                        onChanged: (value) {
                          setState(() {
                            isBiometricEnabled = value;
                          });
                        },
                        activeColor: Colors.orange,
                        title: Text(
                          "Enable Biometric",
                          style: GoogleFonts.merriweather(fontSize: 15.sp),
                        ),
                        secondary: Icon(Icons.fingerprint),
                        inactiveTrackColor: Colors.grey.shade100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
