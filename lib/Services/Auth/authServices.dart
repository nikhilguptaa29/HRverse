import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return result.user;
    } catch (e) {
      throw Exception("User unle to sign in: $e");
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
