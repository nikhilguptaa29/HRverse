class Leaverequest {
  final String id;
  final String empId;
  final String empName;
  final String mngrId;
  final String startDate;
  final String endDate;
  final String status;
  final String leaveType;
  final String reason;

  Leaverequest({
    required this.id,
    required this.empId,
    required this.empName,
    required this.mngrId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.leaveType,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'enployeeId': empId,
      'enployeeName': empName,
      'managerId': mngrId,
      'startDate': startDate,
      'endDate': endDate,
      'leaveType': leaveType,
      'status': status,
      'reason': reason,
    };
  }

  factory Leaverequest.fromMap(String id, Map<String, dynamic> map) {
    return Leaverequest(
      id: id,
      empId: map['employeeId'],
      mngrId: map['managerId'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      status: map['status'],
      leaveType: map['leaveType'],
      reason: map['reason'],
      empName: map['employeeName'],
    );
  }
}
