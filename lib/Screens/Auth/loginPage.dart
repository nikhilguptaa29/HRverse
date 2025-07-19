import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Dashboards/empDash.dart';
import 'package:hrverse/Services/Attendance/attendanceServices.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:hrverse/Utils/Widgets/textform.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      attendanceServices.getLocation();
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final Authservices _auth = Authservices();
  final AttendanceServices attendanceServices = AttendanceServices();

  void _login() async {
    final authProvider = Provider.of<Authprovider>(context, listen: false);

    final result = await authProvider.signIn(
      emailController.text.trim(),
      passController.text.trim(),
    );

    if (result) {
      final id = FirebaseAuth.instance.currentUser!.uid;

      Provider.of<AttendanceProvider>(context, listen: false).start(id);
      final role = authProvider.role;
      if (role == "HR" && kIsWeb) {
        Navigator.pushNamed(context, '/hr');
      } else {
        Navigator.pushNamed(context, '/main');
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.grey,
        body: Stack(
          children: [
            Container(
              width: 1.sw,
              decoration: BoxDecoration(color: Colors.blueGrey.shade100),
            ),
            Container(
              width: 1.sw,
              height: 0.24.sh,
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
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  // textAlign: TextAlign.center,
                  style: GoogleFonts.merriweather(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    // fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ),
            Positioned(
              top: 240.h,
              left: 35.w,
              child: Container(
                width: 0.8.sw,
                height: 0.45.sh,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(color: Colors.transparent, width: 0.5),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 45.0.h),
                      child: MyTextForm(
                        hntTxt: "Email",
                        lblTxt: "Email Address",
                        isPass: false,
                        controller: emailController,
                        type: TextInputType.emailAddress,
                      ),
                    ),
                    MyTextForm(
                      hntTxt: "Password",
                      lblTxt: "Password",
                      isPass: true,
                      controller: passController,
                      type: TextInputType.text,
                    ),
                    SizedBox(height: 40.h),
                    MyButton(
                      btnTxt: "Login",
                      func: () {
                        _login();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // body: Padding(
        //   padding: EdgeInsets.only(top: 0.08.sh),
        //   child: SingleChildScrollView(
        //     child: Column(
        //       // mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         Lottie.asset("Assets/Lottie/login1 2.json", height: 150.h),
        //         SizedBox(height: 30.h),
        //         Text(
        //           "Login",
        //           style: GoogleFonts.maitree(
        //             fontSize: 25.0.sp.clamp(15.sp, 25.sp),
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //         SizedBox(height: 20.h),
        //         MyTextForm(
        //           hntTxt: 'Email Address',
        //           lblTxt: "Email",
        //           isPass: false,
        //           controller: emailController,
        //           type: TextInputType.emailAddress,
        //           prefixIcon: Icon(Icons.email),
        //         ),
        //         // SizedBox(height: 20,),
        //         MyTextForm(
        //           hntTxt: "Password",
        //           lblTxt: "Password",
        //           isPass: true,
        //           controller: passController,
        //           type: TextInputType.text,
        //           prefixIcon: Icon(Icons.lock),
        //           suffixIcon: Icon(Icons.visibility),
        //         ),
        //         Padding(
        //           padding: EdgeInsets.symmetric(
        //             horizontal: 15.w,
        //             vertical: 12.h,
        //           ),
        //           child: Padding(
        //             padding: EdgeInsets.only(right: 5.w, top: 5.h),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.end,
        //               children: [
        //                 Text(
        //                   "Don't have an Account ?? ",
        //                   style: GoogleFonts.roboto(
        //                     fontSize: 15.sp,
        //                     fontWeight: FontWeight.w600,
        //                     color: Colors.black,
        //                   ),
        //                 ),
        //                 InkWell(
        //                   onTap: () {
        //                     Navigator.pushNamed(context, '/signup');
        //                   },
        //                   child: Text(
        //                     "Signup",
        //                     style: GoogleFonts.roboto(
        //                       fontSize: 15.sp,
        //                       fontWeight: FontWeight.w700,
        //                       color: Colors.indigoAccent,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         MyButton(
        //           btnTxt: 'Login',
        //           func: () {
        //             _login();
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
