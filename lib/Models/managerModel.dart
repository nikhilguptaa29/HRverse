class ManagerModel {
  final String reportingManager;
  final String managerMail;

  ManagerModel({
    required this.reportingManager,
    required this.managerMail,
  });

  Map<String, dynamic> toMap() {
    return {
      'reportingManager': reportingManager,
      'managerMail': managerMail,
    };
  }

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      reportingManager: map['reportingManager'],
      managerMail: map['managerMail'],
    );
  }
}
