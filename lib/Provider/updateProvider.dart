import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Updateprovider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<TextEditingController> _controllers = [];
  List<TextEditingController> get controllers => _controllers;

  void initializeController(int count) {
    _controllers = List.generate(count, (index) => TextEditingController());
    notifyListeners();
  }

  void clearControllers() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
  }

  Future<bool> updateUser(String id, String selection) async {
    try {
      if (selection == "Email") {
        await _firestore.collection("Employees").doc(id).update({
          "Email": _controllers[1].text.trim(),
        });
        return true;
      } else if (selection == "Leaves") {
        await _firestore.collection("Employees").doc(id).update({
          'Casual Leave': _controllers[1].text.trim(),
          'Paid Leave': _controllers[2].text.trim(),
          'Sick Leave': _controllers[3].text.trim(),
          //When you will store comp off form add employee page then this will use.....

          // 'Comp Off': _controllers[4].text.trim(),
        });
        return true;
      }
    } catch (e) {
      throw Exception("Unable to update");
    }
    return false;
  }
}
