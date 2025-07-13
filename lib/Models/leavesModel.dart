class LeaveModel {
  final String casualLeaves;
  final String paidLeave;
  final String sickLeave;
  final String compOff;
  final int leavesCount;

  LeaveModel({
    required this.casualLeaves,
    required this.paidLeave,
    required this.sickLeave,
    required this.compOff,
    required this.leavesCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'casualLeaves': casualLeaves,
      'paidLeave': paidLeave,
      'sickLeave': sickLeave,
      'compOff': compOff,
      'leavesCount': leavesCount,
    };
  }

  factory LeaveModel.fromMap(Map<String, dynamic> map) {
    return LeaveModel(
      casualLeaves: map['casualLeaves'],
      paidLeave: map['paidLeave'],
      sickLeave: map['sickLeave'],
      compOff: map['compOff'],
      leavesCount: map['leavesCount'],
    );
  }
}
