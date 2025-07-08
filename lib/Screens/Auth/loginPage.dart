import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Screens/Auth/Dashboards/empDash.dart';
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
    attendanceServices.getLocation();
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
      final role = authProvider.role;
      if (role == "HR") {
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
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Lottie.asset("Assets/Lottie/login1 2.json", height: 200),
              SizedBox(height: 40),
              Text(
                "Login",
                style: GoogleFonts.maitree(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              MyTextForm(
                hntTxt: 'Email Address',
                lblTxt: "Email",
                isPass: false,
                controller: emailController,
                type: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email),
              ),
              // SizedBox(height: 20,),
              MyTextForm(
                hntTxt: "Password",
                lblTxt: "Password",
                isPass: true,
                controller: passController,
                type: TextInputType.text,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Don't have an Account ?? ",
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "Signup",
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MyButton(
                btnTxt: 'Login',
                func: () {
                  _login();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
