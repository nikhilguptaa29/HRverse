class EmployeeModel {
  final String uid;
  final String empCode;
  final String name;
  final String role;
  final String email;
  final String pass;
  final String dob;

  EmployeeModel({
    required this.uid,
    required this.empCode,
    required this.name,
    required this.role,
    required this.email,
    required this.pass,
    required this.dob,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'empCode': empCode,
      'Name': name,
      'Email': email,
      'Pass': pass,
      'Role': role,
      'Date of Birth': dob,
    };
  }
   factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      uid: map['uid'],
      empCode: map['empCode'],
      name: map['Name'],
      email: map['Email'],
      pass: map['Pass'],
      role: map['Role'],
      dob: map['Date of Birth'],
    );
  }
}
