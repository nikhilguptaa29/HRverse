import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Models/leaveRequestModel.dart';
import 'package:hrverse/Models/leavesModel.dart';
import 'package:hrverse/Utils/Widgets/Leave%20Helper/leaveRequest.dart';
import 'package:intl/intl.dart';

class LeaveProvider extends ChangeNotifier {
  LeaveModel? _leaveModel;

  LeaveModel? get leaveModel => _leaveModel;
  Map<String, String> _leaveFieldMap = {
    'Casual Leave': 'casualLeaves',
    'PL': 'paidLeave',
    'Sick Leave': 'sickLeave',
    'Comp Off': 'compOff',
    // 'Leave Without Pay': 'leaveWithoutPay', // add if needed
    // 'PL-Reserved'      : 'plReserved',      // add if needed
  };
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _pendingLeaves = [];

  List<Map<String, dynamic>> get pendingLeaves => _pendingLeaves;
  Future<void> fetchLeaveBalance(String userId) async {
    final doc = await _firestore.collection("Employees").doc(userId).get();

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
    required String managerId,
    required String leaveType,
    required int leaveCount,
    required String fromDate,
    required String toDate,
  }) async {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      // Fetch Current leave balance or count

      final doc = await _firestore.collection("Employees").doc(userId).get();
      final data = doc.data();
      final mapLeave = _leaveFieldMap[leaveType];

      if (data == null) return 'Leave Summary not found';

      int currentBalance = data[mapLeave];

      //Check if leaves are enough

      if (currentBalance < leaveCount)
        return 'Not sufficient $leaveType leaves';

      // Create leave request and make a document data in Firebase

      await _firestore.collection("Leave Requests").add({
        'empId': userId,
        'empName': userName,
        'managerName': managerName,
        'managerMail': managerMail,
        'managerId': managerId,
        'leaveType': leaveType,
        'leaveCount': leaveCount,
        'fromDate': fromDate,
        'toDate': toDate,
        'status': "pending",
        "timeStamp": FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return '$e';
      throw Exception('Error: $e');
    }
  }

  Stream<List<Leaverequest>> fetchPendingManager(String mngrId) {
    return _firestore
        .collection('Leave Requests')
        .where('managerId', isEqualTo: mngrId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snaps) =>
              snaps.docs
                  .map((doc) => Leaverequest.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }
  Stream<List<Leaverequest>> leaveDetailUser(String userId) {
    return _firestore
        .collection('Leave Requests')
        .where('empId', isEqualTo: userId).orderBy('timeStamp',descending: true)
        .snapshots()
        .map(
          (snaps) =>
              snaps.docs
                  .map((doc) => Leaverequest.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }
}
