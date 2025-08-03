import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DailyAttendance {
  final String date;
  final String checkIn;
  final String checkOut;
  final Duration workHours;

  DailyAttendance({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.workHours,
  });

  factory DailyAttendance.fromMap(String date, Map<String, dynamic> map) {
    String inTime = '--:--', outTime = '--:--';
    Duration hours = Duration.zero;

    if (map['Check-In'] != null && map['Check-In']['Time'] != null) {
      DateTime inDate = (map['Check-In']['Time'] as Timestamp).toDate();
      inTime = DateFormat.Hm().format(inDate);

      if (map['Check-Out'] != null && map['Check-Out']['Time'] != null) {
        DateTime outDate = (map['Check-Out']['Time'] as Timestamp).toDate();
        outTime = DateFormat.Hm().format(outDate);
        hours = outDate.difference(inDate);
      }
    }
    return DailyAttendance(
      date: date,
      checkIn: inTime,
      checkOut: outTime,
      workHours: hours,
    );
  }
}
