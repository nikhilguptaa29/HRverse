import 'package:cloud_firestore/cloud_firestore.dart';
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
double distance = await Geolocator.distanceBetween(
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
          .collection("Daily Attendance")
          .doc(todayDate)
          .collection(userName)
          .doc(userId)
          .set({
            "Check-In": {
              "Time": FieldValue.serverTimestamp(),
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

  Future<bool> checkOut(String userId, String userName) async {
    Position position = await Geolocator.getCurrentPosition();
    bool isWithinRadius = await isWithInRadius(position);

    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    if (!isWithinRadius) {
      throw Exception("Please mark your attendance from office location");
    }
    try {
      await _firestore
          .collection("Daily Attendance")
          .doc(todayDate)
          .collection(userName)
          .doc(userId)
          .set({
            "Check-Out": {
              "Time": FieldValue.serverTimestamp(),
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

  Future<Map<String, String>> todayAttendance(
    String userId,
    String userName,
  ) async {
    {
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      var doc = _firestore
          .collection("Daily Attendance")
          .doc(todayDate)
          .collection(userName)
          .doc(userId);

      var snapshot = await doc.get();

      String checkInTime = '--:--';
      String checkOutTime = '--:--';

      if (snapshot.exists) {
        var data = snapshot.data();
        if (data?['Check-In'] != null) {
          DateTime checkIn = (data!['Check-In'] ['Time'] as Timestamp).toDate();
          checkInTime = DateFormat('HH:mm').format(checkIn);
        }
        if (data?['Check-Out'] != null) {
          DateTime checkOut = (data!['Check-Out'] ['Time'] as Timestamp).toDate();
          checkOutTime = DateFormat('HH:mm').format(checkOut);
        }
      }
      return {
        'Check-In': checkInTime,
        'Check-Out': checkOutTime,
        ' Date': todayDate,
      };
    }
  }
}
