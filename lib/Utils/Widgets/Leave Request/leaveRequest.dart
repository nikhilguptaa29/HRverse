import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:intl/intl.dart';

class LeaveRequest extends StatefulWidget {
  LeaveRequest({super.key});

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
  final formatter = DateFormat('dd-mm-yyyy');

  void calculateLeaves() {
    final dateFrom = formatter.parse(fromDate.text);
    final dateTo = formatter.parse(toDate.text);
    int difference = dateTo.difference(dateFrom).inDays + 1;
    totalLeaves.text = difference.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDate.text = DateFormat('dd-MM-yyyy').format(todayDate);
    toDate.text = DateFormat('dd-MM-yyyy').format(todayDate);
    calculateLeaves();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    void fromdDatePicker() {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: todayDate,
              backgroundColor: Colors.white,
              // dateOrder: DatePickerDateOrder.dmy,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  todayDate = newDate;
                  fromDate.text = DateFormat('dd-MM-yyyy').format(newDate);
                  calculateLeaves();
                });
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
              // dateOrder: DatePickerDateOrder.dmy,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  todayDate = newDate;
                  toDate.text = DateFormat('dd-MM-yyyy').format(newDate);
                  calculateLeaves();
                });
              },
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2),
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
        child: Form(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 25, bottom: 0),
                child: Row(
                  children: [
                    Text(
                      "Leave Type",
                      style: GoogleFonts.merriweather(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
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
                  ),
                  dropdownColor: Colors.purple.shade50,
                  hint: Text("Select Leave"),
                  value: selectLeave,
                  // menuMaxHeight: 175,
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25, right: 115),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "From Date",
                      style: GoogleFonts.merriweather(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "To Date",
                      style: GoogleFonts.merriweather(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 10),
                      child: TextFormField(
                        readOnly: true,
                        onTap: fromdDatePicker,
                        controller: fromDate,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        readOnly: true,
                        onTap: toDatePicker,
                        controller: toDate,
                        decoration: InputDecoration(
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25),
                child: Row(
                  children: [
                    Text(
                      "No. of Leaves",
                      style: GoogleFonts.merriweather(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: totalLeaves,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25),
                child: Row(
                  children: [
                    Text(
                      "Full Day / Half Day",
                      style: GoogleFonts.merriweather(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 10,
                ),
                child: DropdownButtonFormField(
                  items:
                      leaveDuration
                          .map(
                            (durationLeave) => DropdownMenuItem(
                              child: Text(durationLeave),
                              value: durationLeave,
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() {
                        selectLeaveDuration = value;
                      }),
                  decoration: InputDecoration(
                    hintText: 'Select Duration',
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
                  ),
                  value: selectLeaveDuration,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25),
                child: Row(
                  children: [
                    Text(
                      "Reason",
                      style: GoogleFonts.merriweather(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 10,
                ),
                child: DropdownButtonFormField(
                  items:
                      reasonList
                          .map(
                            (reasons) => DropdownMenuItem(
                              child: Text(reasons),
                              value: reasons,
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() {
                        selectReason = value;
                      }),
                  decoration: InputDecoration(
                    hintText: 'Select Reason',
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
                  ),
                  value: selectReason,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25),
                child: Row(
                  children: [
                    Text(
                      "Remarks",
                      style: GoogleFonts.merriweather(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 10,
                ),
                child: TextFormField(
                  controller: remarksController,
                  decoration: InputDecoration(
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
                  ),
                ),
              ),
              MyButton(btnTxt: 'Apply', func: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
