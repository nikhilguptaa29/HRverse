import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Screens/Auth/Dashboards/empDash.dart';
import 'package:hrverse/Screens/Auth/Dashboards/hrDash.dart';
import 'package:hrverse/Screens/Auth/Dashboards/managerDash.dart';
import 'package:hrverse/Screens/Auth/loginPage.dart';
import 'package:hrverse/Screens/Auth/signupPage.dart';
import 'package:hrverse/Screens/mainScreen.dart';
import 'package:hrverse/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authprovider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HRverse',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/hr': (context) => HrDash(),
        '/emp': (context) => EmployeeDash(),
        '/mngr': (context) => ManagerDash(),
        '/main': (context) => MainScreen(),
        // '/':(context)=>
      },
      initialRoute: '/login',
    );
  }
}
