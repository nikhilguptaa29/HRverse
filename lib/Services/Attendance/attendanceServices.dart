import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AttendanceServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  static const double long = 77.06065759105084;
  static const double lat = 28.47764880548407;
  static const double radius = 50000000000.0;

  // 28.47764880548407, 77.06065759105084
  Future<bool> isWithInRadius(Position position) async {
    print("User location: ${position.latitude}, ${position.longitude}");
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      lat,
      long,
    );
    print("Distance from office: $distance meters");
    return distance <= radius;
  }

  // To get user's location

  Future<Position?> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location Services are disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "Location Permission denied permanently.. So we cannot get location",
      );
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        throw Exception("Location Permission are denied");
      }
    }
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }
  // / To give user a permission of mark the attendance

  Future<bool> checkIn(String userId, String userName) async {
    Position? position = await getLocation();
    bool isWithinRadius = await isWithInRadius(position!);

    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    if (!isWithinRadius) {
      return false;
      // throw Exception("Please mark your attendance from office location");
    }
    try {
      await _firestore
          .collection("dailyAttendance")
          .doc(todayDate)
          .collection("Attendance")
          .doc(userId)
          .set({
            "Emp Id": userId,
            "Name": userName,
            "Check-In": {
              "Time": FieldValue.serverTimestamp(),
              "Client Time": DateTime.now(),
              "Status": "Present",
              "Latitude": position.latitude,
              "Longitude": position.longitude,
            },
          }, SetOptions(merge: true));
      return true;
    } catch (e) {
      throw Exception("Error Occured : $e");
    }
  }

  Future<List<String>> getMonths(String userId) async {
    Set<String> months = {};
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("dailyAttendance").get();
      print("No. of length: ${snapshot.docs.length}");

      if (snapshot.docs.isEmpty) {
        print("Data not found, Check name ");
      } else {
        for (var doc in snapshot.docs) {
          String dateStr = doc.id;
          print("Doc Id found: $dateStr");

          DateTime date = DateFormat('dd-MM-yyyy').parse(dateStr);
          String formatMonth = DateFormat('MMMM yyyy').format(date);
          months.add(formatMonth);
        }
      }
    } catch (e) {
      print("Invalid month Format :$e");
    }
    List<String> sortMonth =
        months.toList()..sort(
          (a, b) => DateFormat(
            'MMMM yyyy',
          ).parse(a).compareTo(DateFormat('MMMM yyyy').parse(b)),
        );

    print("Final Months List: $sortMonth");
    return sortMonth;
  }

  Future<List<Map<String, String>>> getMonthlyAttedance(
    String userId,
    String month,
  ) async {
    QuerySnapshot snapshot =
        await _firestore.collection("dailyAttendance").get();
    List<Map<String, String>> attendanceList = [];
    for (var doc in snapshot.docs) {
      String dateStr = doc.id;
      try {
        DateTime dt = DateFormat('dd-MM-yyyy').parse(dateStr);
        if (DateFormat('MMMM yyyy').format(dt) == month) {
          DocumentSnapshot userDoc =
              await _firestore
                  .collection("dailyAttendance")
                  .doc(dateStr)
                  .collection("Attendance")
                  .doc(userId)
                  .get();

          if (userDoc.exists) {
            final data = userDoc.data() as Map<String, dynamic>;

            String checkIn = '--:--';
            String checkOut = '--:--';
            String total = '--:--';

            if (data['Check-In']?['Time'] != null &&
                data['Check-In']['Time'] is Timestamp) {
              checkIn = DateFormat.Hm().format(
                (data['Check-In']['Time'] as Timestamp).toDate(),
              );
            }
            if (data['Check-Out']?['Time'] != null &&
                data['Check-Out']['Time'] is Timestamp) {
              checkOut = DateFormat.Hm().format(
                (data['Check-Out']['Time'] as Timestamp).toDate(),
              );

              Duration difference = ((data['Check-Out']['Time'] as Timestamp)
                      .toDate())
                  .difference((data['Check-In']['Time'] as Timestamp).toDate());

              total =
                  '${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}';
            }
            attendanceList.add({
              'date': dateStr,
              'checkIn': checkIn,
              'checkOut': checkOut,
              'total': total,
            });
          }
        }
      } catch (_) {}
    }
    attendanceList.sort(
      (a, b) => DateFormat(
        'dd-MM-yyyy',
      ).parse(a['date']!).compareTo(DateFormat('dd-MM-yyyy').parse(a['date']!)),
    );
    return attendanceList;
  }

  Future<bool> checkOut(String userId, String userName) async {
    Position position = await Geolocator.getCurrentPosition();
    bool isWithinRadius = await isWithInRadius(position);

    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    if (!isWithinRadius) {
      throw Exception("Please mark your attendance from office location");
    }
    try {
      await _firestore
          .collection("dailyAttendance")
          .doc(todayDate)
          .collection("Attendance")
          .doc(userId)
          .set({
            "Emp Id": userId,
            "Name": userName,
            "Check-Out": {
              "Time": FieldValue.serverTimestamp(),
              "Client Time": DateTime.now(),
              "Status": "Present",
              "Latitude": position.latitude,
              "Longitude": position.longitude,
            },
          }, SetOptions(merge: true));
      return true;
    } catch (e) {
      throw Exception("Error Occured : $e");
    }
  }

  Stream<Map<String, String>> todayAttendance(String userId) {
    {
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      return _firestore
          .collection("dailyAttendance")
          .doc(todayDate)
          .collection("Attendance")
          .doc(userId)
          .snapshots()
          .map((snap) {
            String inTime = '--:--';
            String outTime = '--:--';

            if (snap.exists) {
              final data = snap.data()!;
              if (data['Check-In'] != null &&
                  data['Check-In']['Time'] is Timestamp) {
                final dt = (data['Check-In']['Time'] as Timestamp).toDate();
                inTime = DateFormat.Hm().format(dt);
              }
              if (data['Check-Out'] != null &&
                  data['Check-Out']['Time'] is Timestamp) {
                final dt = (data['Check-Out']['Time'] as Timestamp).toDate();
                outTime = DateFormat.Hm().format(dt);
              }
            }
            return {'checkIn': inTime, 'checkOut': outTime};
          });
    }
  }
}
