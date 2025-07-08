import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Services/Attendance/attendanceServices.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceServices _attendanceServices = AttendanceServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _checkInTime = '--:--';
  String _checkOutTime = '--:--';
  String _date = '';
  Duration _timeCheckIn = Duration.zero;

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
  bool get isLoading => _isLoading;
  bool get isCheckInStatus => _isCheckInStatus;
  bool get isCheckOutStatus => _isCheckOutStatus;
  bool get isCheckOut => _isCheckOut;
  bool get isCheckIn => _isCheckIn;
  bool get checkInDone => _checkInDone;
  bool get canCheckOut => _canCheckOut;
  Duration get timeCheckIn => _timeCheckIn;

  Future<void> fetchDailyAttendance(String userId, String userName) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, String> data = await _attendanceServices.todayAttendance(
        userId,
        userName,
      );
      _checkInTime = data['Check-In'] ?? '--;--';
      _checkOutTime = data['Check-Out'] ?? '--:--';
      _date = data['Date'] ?? '';

      // Get checkIn timestamp from firebase

      if (_date!.isNotEmpty) {
        var doc =
            await _attendanceServices.firestore
                .collection("Daily Attendance")
                .doc(_date)
                .collection(userName)
                .doc(userId)
                .get();

        _checkInDone = false;
        _canCheckOut = false;

        if (doc.exists && doc.data()?['Check-In'] != null) {
          Timestamp checkInTimeStamp = doc.data()!['Check-In']['Time'];
          DateTime checkInTime = checkInTimeStamp.toDate();

          _checkInDone = true;
          _timeCheckIn = DateTime.now().difference(checkInTime);
          _canCheckOut = _timeCheckIn.inSeconds >= 10;
        }
      }
    } catch (e) {
      throw Exception("Unable to fetch Attendance: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkIn(String userId, String userName) async {
    _isCheckInStatus = true;
    _isCheckIn = false;

    try {
      bool result = await _attendanceServices.checkIn(userId, userName);
      _isCheckIn = result;

      if (result) {
        await fetchDailyAttendance(userId, userName);
        return true;
      }
    } catch (e) {
      throw Exception("Unable to check in :$e");
    }
    _isCheckInStatus = false;
    return false;
    notifyListeners();
  }

  Future<void> checkOut(String userId, String userName) async {
    _isCheckOutStatus = true;
    _isCheckOut = false;

    try {
      bool result = await _attendanceServices.checkOut(userId, userName);
      _isCheckOut = result;

      if (result) {
        await fetchDailyAttendance(userId, userName);
      }
    } catch (e) {
      throw Exception("Unable to check in :$e");
    }
    _isCheckOutStatus = false;
    notifyListeners();
  }
}
