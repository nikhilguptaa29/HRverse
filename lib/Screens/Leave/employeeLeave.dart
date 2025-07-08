import 'package:flutter/material.dart';

class EmployeeLeave extends StatefulWidget {
  const EmployeeLeave({super.key});

  @override
  State<EmployeeLeave> createState() => _EmployeeLeaveState();
}

class _EmployeeLeaveState extends State<EmployeeLeave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Employee Leave")));
  }
}
