import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int?> countMale() async {
    try {
      AggregateQuerySnapshot snapshot =
          await _firestore.collection('Employees').count().get();
      return snapshot.count;
    } catch (e) {
      throw Exception("Error :$e");
    }
  }

  Future<User?> signIn(String email, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return result.user;
    } catch (e) {
      throw Exception("User unable to sign in: $e");
    }
  }

  // Future<> searchUser(String id) async{
  //   try{
  //     QuerySnapshot snapshot = await _firestore.collection("Employees").where("Emp Code",isEqualTo: id).get();

  //     final List<Map<String,dynamic>> userData = [];

  //     snapshot.docs.forEach((doc){
  //       userData.add(doc.data() as Map<String,dynamic>);
  //     });
  //   }
  // }
  Future<bool> createEmployee(
    String empId,
    String name,
    String email,
    String role,
    String gender,
    String designation,
    String manager,
    String managerMail,
    String dob,
    String cl,
    String pl,
    String? sl,
    String? compOff,
  ) async {
    try {
      String? pass;
      if (name.length >= 3) {
        String char = name.substring(0, 3);
        final year = dob.split('/').last.trim();
        pass = '${char.toLowerCase()}$year';
      }
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass!,
      );

      // Create user with specified CL and PL in their account

      await _firestore.collection('Employees').doc(empId).set({
        "uid": userCred.user!.uid,
        "Emp Code": empId,
        "Name": name,
        "Email": email,
        "Pass":pass,
        "Role": role,
        "Date of Birth": dob,
        "Reporting Manager": manager,
        "Manager mail": managerMail,
        "Created at": FieldValue.serverTimestamp(),
        "Leaves": {
          "Casual Leaves": cl,
          "Paid Leave": pl,
          "Sick Leave": sl,
          "Comp Off": compOff,
          "Leaves Count":
              int.parse(cl) +
              int.parse(pl) +
              int.parse(sl!) +
              int.parse(compOff!),
        },
      });
      return true;
    } catch (e) {
      throw Exception("Error while creating the Employee");
    }
  }

  Future<User?> signup(
    String email,
    String pass,
    String role,
    String name,
    String gender,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // Storing the user details in firestore

      await _firestore.collection("Employees").doc(result.user!.uid).set({
        "Name": name,
        "Email": email,
        "Gender": gender,
        "Role": role,
      });
      return result.user;
    } catch (e) {
      throw Exception("User unable to create: $e");
    }
  }

  Future<String?> getUserRole(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection("Employees").doc(userId).get();
    return snapshot.get("Role");
  }

  Future<String?> getUserName(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection("Employees").doc(userId).get();
    return snapshot.get("Name");
  }

  Future<String?> getUserGender(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection("Employees").doc(userId).get();
    return snapshot.get("Gender");
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Can't Sign Out: $e");
    }
  }
}
