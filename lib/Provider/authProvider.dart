import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:local_auth/local_auth.dart';

class Authprovider extends ChangeNotifier {
  final Authservices _authservices = Authservices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication localAuth = LocalAuthentication();

  User? _user;
  String? _role;
  String? _name;
  String? _gender;
  String? _designation;
  int _count = 0;
  List<Map<String, dynamic>> _userData = [];
  bool _isUserDetailFetch = false;
  bool _isAuthenticate = false;
  StreamSubscription? _subscription;

  User? get user => _user;
  String? get role => _role;
  String? get designation => _designation;
  String? get name => _name;
  String? get gender => _gender;
  int? get count => _count;
  bool get isAuth => _user != null;
  bool get isAuthenticate => _isAuthenticate;
  bool get isUserDetailFetch => _isUserDetailFetch;
  List<Map<String, dynamic>> get userData => _userData;

  void userCount() {
    _subscription = _firestore.collection('Employees').snapshots().listen((
      QuerySnapshot snapshot,
    ) {
      _count = snapshot.docs.length;
      notifyListeners();
    });
  }

  void stopSub() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<bool> biometricAuth() async {
    try {
      _isAuthenticate = await localAuth.authenticate(
        localizedReason: "Authenticate for Check-In Successfully",
        options: AuthenticationOptions(stickyAuth: true, useErrorDialogs: true),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // ...
      } else {
        // ...
      }
    } catch (e) {
      throw Exception("$e");
    }
    return isAuthenticate;
  }

  Future<void> userDetail(String id) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection("Employees")
              .where("Emp Code", isEqualTo: id)
              .get();

      if (snapshot.docs.isNotEmpty) {
        _userData =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
        _isUserDetailFetch = true;
      } else {
        _isUserDetailFetch = false;
      }
    } catch (e) {
      _isUserDetailFetch = false;
      throw Exception("Error fetching user Details : $e");
    }
    notifyListeners();
  }

  Future<bool> deleteUser(String empId) async {
    try {
      final snapshot =
          await _firestore
              .collection("Employees")
              .where("Emp Code", isEqualTo: empId)
              .get();

      for (var doc in snapshot.docs) {
        await _firestore.collection("Employees").doc(doc.id).delete();
        return true;
      }
    } catch (e) {
      throw Exception("Failed to delete the user : $e");
    }
    notifyListeners();
    return false;
  }

  // Future<void> userCount() async {
  //   try {
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('Employees').get();

  //     _count = snapshot.docs.length;
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error : $e");
  //   }
  // }

  Future<bool> signUp(
    String email,
    String pass,
    String role,
    String name,
    String gender,
  ) async {
    _user = await _authservices.signup(email, pass, role, name, gender);

    if (_user != null) {
      _role = role;
      _name = name;
      _gender = gender;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signIn(String email, String pass) async {
    _user = await _authservices.signIn(email, pass);
    if (_user != null) {
      _role = await _authservices.getUserRole(_user!.uid);
      _name = await _authservices.getUserName(_user!.uid);
      _gender = await _authservices.getUserGender(_user!.uid);
      _designation = await _authservices.getUserDesignation(_user!.uid);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await _authservices.signOut();
    _user = null;
    _role = null;
    _name = null;
    _gender = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stopSub();
    super.dispose();
  }
}
