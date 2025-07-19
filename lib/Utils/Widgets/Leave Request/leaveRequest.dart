import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/leaveProvider.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({super.key});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  void onApplyLeave(BuildContext context) async {
    final Authservices _authservices = Authservices();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String? userId = _auth.currentUser?.uid;
    final String? userName = await _authservices.getUserName(userId!);
    final String? managerName = await _authservices.getManagerName(userId);
    final String? managerMail = await _authservices.getManagerMail(userId);
    final int? leaveCount = int.tryParse(totalLeaves.text);
    final errorMsg = await Provider.of<LeaveProvider>(
      context,
      listen: false,
    ).applyLeave(
      userId: userId,
      userName: userName!,
      managerName: managerName!,
      managerMail: managerMail!,
      leaveType: selectLeave!,
      leaveCount: leaveCount!,
    );

    if (errorMsg == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Leave Applied Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are unable to apply Leave...")),
      );
    }
  }

  final List<String> leaveType = [
    'Casual Leave',
    'Comp Off',
    'PL',
    'PL-Reserved',
    'Sick Leave',
    'Leave Without Pay',
  ];

  final List<String> leaveDuration = ['Full Day', 'Half Day'];
  final List<String> reasonList = [
    'Personal',
    'Travelling',
    'Examination',
    'Family Function',
    'Medical Reason',
    'Others',
  ];

  String? selectLeaveDuration;
  String? selectLeave;
  String? selectReason;

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController totalLeaves = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  DateTime todayDate = DateTime.now();

  final formatter = DateFormat('dd-MM-yyyy');

  void calculateLeaves() {
    final dateFrom = formatter.parse(fromDate.text);
    final dateTo = formatter.parse(toDate.text);
    int difference = dateTo.difference(dateFrom).inDays + 1;
    totalLeaves.text = difference.toString();
  }

  @override
  void initState() {
    super.initState();
    fromDate.text = formatter.format(todayDate);
    toDate.text = formatter.format(todayDate);
    calculateLeaves();
  }

  void fromdDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200.h,
          child: CupertinoDatePicker(
            initialDateTime: todayDate,
            backgroundColor: Colors.white,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              fromDate.text = formatter.format(newDate);
              calculateLeaves();
            },
          ),
        );
      },
    );
  }

  void toDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200.h,
          child: CupertinoDatePicker(
            initialDateTime: todayDate,
            backgroundColor: Colors.white,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              toDate.text = formatter.format(newDate);
              calculateLeaves();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Container(
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100,Colors.blue.shade200, Colors.purple.shade200],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              width: 1.sw,
              // height: height,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Leave Type", style: sectionHeading()),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField(
                      decoration: fieldDecoration(),
                      dropdownColor: Colors.purple.shade50,
                      hint: Text("Select Leave"),
                      value: selectLeave,
                      items:
                          leaveType.map((leaves) {
                            return DropdownMenuItem(
                              value: leaves,
                              child: Text(leaves),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectLeave = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("From Date", style: sectionHeading()),
                        Padding(
                          padding: EdgeInsets.only(right: 85.0.w),
                          child: Text("To Date", style: sectionHeading()),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            onTap: fromdDatePicker,
                            controller: fromDate,
                            decoration: fieldDecoration(),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            onTap: toDatePicker,
                            controller: toDate,
                            decoration: fieldDecoration(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text("No. of Leaves", style: sectionHeading()),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: totalLeaves,
                      readOnly: true,
                      decoration: fieldDecoration(),
                    ),
                    SizedBox(height: 16.h),
                    Text("Full Day / Half Day", style: sectionHeading()),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField(
                      value: selectLeaveDuration,
                      items:
                          leaveDuration.map((durationLeave) {
                            return DropdownMenuItem(
                              value: durationLeave,
                              child: Text(durationLeave),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectLeaveDuration = value!;
                        });
                      },
                      decoration: fieldDecoration(hint: 'Select Duration'),
                    ),
                    SizedBox(height: 16.h),
                    Text("Reason", style: sectionHeading()),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField(
                      value: selectReason,
                      items:
                          reasonList.map((reasons) {
                            return DropdownMenuItem(
                              value: reasons,
                              child: Text(reasons),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectReason = value!;
                        });
                      },
                      decoration: fieldDecoration(hint: 'Select Reason'),
                    ),
                    SizedBox(height: 16.h),
                    Text("Remarks", style: sectionHeading()),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: remarksController,
                      decoration: fieldDecoration(),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 150.w),
                        child: MyButton(
                          btnTxt: 'Apply',
                          func: () {
                            onApplyLeave(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle sectionHeading() {
    return GoogleFonts.merriweather(
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
  }

  InputDecoration fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(),
      ),
    );
  }
}
