import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Models/leavesModel.dart';

class LeaveProvider extends ChangeNotifier {
  LeaveModel? _leaveModel;

  LeaveModel? get leaveModel => _leaveModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> fetchLeaveBalance(String userId) async {
    final doc =
        await _firestore
            .collection("Employees")
            .doc(userId)
            .collection("Leave Details")
            .doc("Sumamry")
            .get();

    if (doc.exists) {
      _leaveModel = LeaveModel.fromMap((doc.data()!));
      notifyListeners();
    }
  }

  Future<String?> applyLeave({
    required String userId,
    required String userName,
    required String managerName,
    required String managerMail,
    required String leaveType,
    required int leaveCount,
  }) async {
    try {
      // Fetch Current leave balance or count

      final doc =
          await _firestore
              .collection("Employee")
              .doc(userId)
              .collection("Leave Details")
              .doc("Summary")
              .get();
      final data = doc.data();

      if (data == null || data[leaveType] == null) return 'Invalid Leave Type';

      int currentBalance = data[leaveType];

      //Check if leaves are enough

      if (currentBalance < leaveCount)
        return 'Not sufficient $leaveType leaves';

      // Create leave request and make a document data in Firebase

      await _firestore.collection("Leave Requests").add({
        'empId': userId,
        'empName': userName,
        'managerName': managerName,
        'managerMail': managerMail,
        'leaveType': leaveType,
        'leaveCount': leaveCount,
        'status': "pending",
        "timeStamp": FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
