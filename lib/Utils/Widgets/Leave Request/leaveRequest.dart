import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:intl/intl.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({super.key});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
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
        return Container(
          height: 200,
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
        return Container(
          height: 200,
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade200, Colors.purple.shade200],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: width,
              // height: height,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Leave Type", style: sectionHeading()),
                    SizedBox(height: 8),
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
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("From Date", style: sectionHeading()),
                        Text("To Date", style: sectionHeading()),
                      ],
                    ),
                    SizedBox(height: 8),
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
                        SizedBox(width: 12),
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
                    SizedBox(height: 16),
                    Text("No. of Leaves", style: sectionHeading()),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: totalLeaves,
                      readOnly: true,
                      decoration: fieldDecoration(),
                    ),
                    SizedBox(height: 16),
                    Text("Full Day / Half Day", style: sectionHeading()),
                    SizedBox(height: 8),
                    DropdownButtonFormField(
                      value: selectLeaveDuration,
                      items:
                          leaveDuration.map((durationLeave) {
                            return DropdownMenuItem(
                              child: Text(durationLeave),
                              value: durationLeave,
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectLeaveDuration = value!;
                        });
                      },
                      decoration: fieldDecoration(hint: 'Select Duration'),
                    ),
                    SizedBox(height: 16),
                    Text("Reason", style: sectionHeading()),
                    SizedBox(height: 8),
                    DropdownButtonFormField(
                      value: selectReason,
                      items:
                          reasonList.map((reasons) {
                            return DropdownMenuItem(
                              child: Text(reasons),
                              value: reasons,
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectReason = value!;
                        });
                      },
                      decoration: fieldDecoration(hint: 'Select Reason'),
                    ),
                    SizedBox(height: 16),
                    Text("Remarks", style: sectionHeading()),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: remarksController,
                      decoration: fieldDecoration(),
                    ),
                    SizedBox(height: 24),
                    Center(child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: MyButton(btnTxt: 'Apply', func: () {}),
                    )),
                    SizedBox(height: 30),
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
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
  }

  InputDecoration fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(),
      ),
    );
  }
}
