import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Models/dailyAttendance.dart';
import 'package:hrverse/Models/leavesModel.dart';
import 'package:hrverse/Services/Attendance/attendanceServices.dart';
import 'package:intl/intl.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceServices _attendanceServices = AttendanceServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  //List of attendance List
  List<DailyAttendance> _attendanceList = [];
  // List of Months for Dropdown
  List<String> _availableMonths = [];

  //Selected Month
  String? _selectedMonth;

  List<DailyAttendance> get attendanceList => _attendanceList;
  List<String> get availableMonths => _availableMonths;
  String? get selectedMonth => _selectedMonth;

  LeaveModel? _leaveModel;

  String _checkInTime = '--:--';
  String _checkOutTime = '--:--';
  String _date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  Duration _timeCheckIn = Duration.zero;
  int _presentCount = 0;
  int _absentCount = 0;
  StreamSubscription? _subscription;
  StreamSubscription? _leaveSub;
  bool _isLoading = false;
  bool _isCheckInStatus = false;
  bool _isCheckOutStatus = false;
  bool _isCheckOut = false;
  bool _isCheckIn = false;
  bool _checkInDone = false;
  bool _canCheckOut = false;

  String get checkInTime => _checkInTime;
  String get checkOutTime => _checkOutTime;
  String get date => _date;
  int get presentCount => _presentCount;
  int get absentCount => _absentCount;
  bool get isLoading => _isLoading;
  bool get isCheckInStatus => _isCheckInStatus;
  bool get isCheckOutStatus => _isCheckOutStatus;
  bool get isCheckOut => _isCheckOut;
  bool get isCheckIn => _isCheckIn;
  bool get checkInDone => _checkInDone;
  bool get canCheckOut => _canCheckOut;
  Duration get timeCheckIn => _timeCheckIn;
  LeaveModel? get leaveModel => _leaveModel;

  AttendanceProvider() {
    fetchMonthsList();
  }

  set selectedMonth(String? value) {
    _selectedMonth = value;
    notifyListeners();
  }

  void start(String userId) {
    _subscription?.cancel();
    _subscription = _attendanceServices.todayAttendance(userId).listen((
      result,
    ) {
      _checkInTime = result['checkIn'] ?? '--:--';
      _checkOutTime = result['checkOut'] ?? '--:--';
      notifyListeners();
    });
  }

  Future<void> fetchLeaveBalance(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("Employees").doc(userId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        _leaveModel = LeaveModel(
          casualLeaves: data['casualLeaves'].toString(),
          paidLeave: data['paidLeave'].toString(),
          sickLeave: data['sickLeave'].toString(),
          compOff: data['compOff'].toString(),
          leavesCount: data['leavesCount'],
        );
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Error while Fetching Leave balance: $e");
    }
  }

  void fetchMonthsList() async {
    _attendanceList.clear();
    _availableMonths.clear();

    print("Fetching Months");

    final snapshots = await _firestore.collection("dailyAttendance").get();
    print(snapshots.docs.length);

    final setMonth = <String>{};

    for (final doc in snapshots.docs) {
      String dateStr = doc.id;
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dateStr);
      String monthName = DateFormat('yyyy-MM').format(parsedDate);
      setMonth.add(monthName);
    }
    _availableMonths = setMonth.toList()..sort();
    print("$_availableMonths");
    notifyListeners();
  }

  void selectMonth(String month) {
    _selectedMonth = month;
    _fetchMonthlyAttendance(month);
    print(_selectedMonth);
    notifyListeners();
  }

  void _fetchMonthlyAttendance(String month) {
    _attendanceList.clear();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    _firestore.collection("dailyAttendance").snapshots().listen((event) async {
      List<DailyAttendance> temp = [];

      for (final doc in event.docs) {
        String dateStr = doc.id;
        DateTime dt = DateFormat('dd-MM-yyyy').parse(dateStr);
        String monthValue = DateFormat('yyyy-MM').format(dt);

        if (monthValue == month) {
          var attendanceDoc =
              await doc.reference.collection("Attendance").doc(userId).get();

          if (attendanceDoc.exists) {
            final attendanceData = attendanceDoc.data()!;
            temp.add(DailyAttendance.fromMap(dateStr, attendanceData));
          }
        }
      }
      _attendanceList = temp;
      notifyListeners();
    });
  }

  void dailyAttendanceCount() {
    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    _firestore
        .collection('dailyAttendance')
        .doc(todayDate)
        .collection("Attendance")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          int present = 0;
          int absent = 0;
          for (var doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            if (data['Check-In']['Status'] == "Present") {
              present++;
            }
            if (data['Check-In']['Status'] == "Absent") {
              absent++;
            }
          }
          _presentCount = present;
          _absentCount = absent;
          notifyListeners();
        });
  }

  // Future<void> fetchDailyAttendance(String userId) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     Map<String, String> data = await _attendanceServices.todayAttendance(
  //       userId,
  //     );
  //     _checkInTime = data['Check-In'] ?? '--;--';
  //     _checkOutTime = data['Check-Out'] ?? '--:--';
  //     _date = data['Date'] ?? '';

  //     // Get checkIn timestamp from firebase

  //     if (_date!.isNotEmpty) {
  //       var doc =
  //           await _attendanceServices.firestore
  //               .collection("dailyAttendance")
  //               .doc(_date)
  //               .collection("Attendance")
  //               .doc(userId)
  //               .get();

  //       _checkInDone = false;
  //       _canCheckOut = false;

  //       if (doc.exists && doc.data()?['Check-In'] != null) {
  //         Timestamp checkInTimeStamp = doc.data()!['Check-In']['Time'];
  //         DateTime checkInTime = checkInTimeStamp.toDate();

  //         _checkInDone = true;
  //         _timeCheckIn = DateTime.now().difference(checkInTime);
  //         _canCheckOut = _timeCheckIn.inSeconds >= 10;
  //       }
  //     }
  //   } catch (e) {
  //     throw Exception("Unable to fetch Attendance: $e");
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<bool> checkIn(String userId, String userName) async {
    _isCheckInStatus = true;
    _isCheckIn = false;

    try {
      bool result = await _attendanceServices.checkIn(userId, userName);
      _isCheckIn = result;

      if (result) {
        await _attendanceServices.todayAttendance(userId);
        return true;
      }
    } catch (e) {
      throw Exception("Unable to check in :$e");
    }
    _isCheckInStatus = false;
    notifyListeners();
    return false;
  }

  Future<bool> checkOut(String userId, String userName) async {
    _isCheckOutStatus = true;
    _isCheckOut = false;

    try {
      bool result = await _attendanceServices.checkOut(userId, userName);
      _isCheckOut = result;

      if (result) {
        await _attendanceServices.todayAttendance(userId);
        return true;
      }
    } catch (e) {
      throw Exception("Unable to check out :$e");
    }
    _isCheckOutStatus = false;
    notifyListeners();
    return false;
  }

  // Future<void> checkOut(String userId, String userName) async {
  //   _isCheckOutStatus = true;
  //   _isCheckOut = false;

  //   try {
  //     bool result = await _attendanceServices.checkOut(userId, userName);
  //     _isCheckOut = result;

  //     if (result) {
  //       await fetchDailyAttendance(userId);
  //     }
  //   } catch (e) {
  //     throw Exception("Unable to check in :$e");
  //   }
  //   _isCheckOutStatus = false;
  //   notifyListeners();
  // }
}
