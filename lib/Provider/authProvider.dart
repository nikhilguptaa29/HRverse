import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Services/Auth/authServices.dart';

class Authprovider extends ChangeNotifier {
  final Authservices _authservices = Authservices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _role;
  String? _name;
  String? _gender;
  int _count = 0;
  List<Map<String, dynamic>> _userData = [];
  bool _isUserDetailFetch = false;

  User? get user => _user;
  String? get role => _role;
  String? get name => _name;
  String? get gender => _gender;
  int? get count => _count;
  bool get isAuth => _user != null;
  bool get isUserDetailFetch => _isUserDetailFetch;
  List<Map<String, dynamic>> get userData => _userData;

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

  Future<void> userCount() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Employees').get();

      _count = snapshot.docs.length;
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

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
}
