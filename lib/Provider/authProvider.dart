import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Services/Auth/authServices.dart';

class Authprovider extends ChangeNotifier {
  final Authservices _authservices = Authservices();

  User? _user;
  String? _role;
  String? _name;
  String? _gender;

  User? get user => _user;
  String? get role => _role;
  String? get name => _name;
  String? get gender => _gender;
  bool get isAuth => _user != null;

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
