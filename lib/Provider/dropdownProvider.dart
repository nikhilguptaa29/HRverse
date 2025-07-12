import 'package:flutter/material.dart';

class Dropdownprovider extends ChangeNotifier {
  String _selectedOption = '';

  String get selectOption => _selectedOption;

  void set selectOption(String value) {
    _selectedOption = value;
    notifyListeners();
  }

  int get textFieldCount {
    switch (_selectedOption) {
      case 'Leaves':
        return 5;
      case 'Email':
        return 2;
      default:
        return 0;
    }
  }

  String getLabel(int index) {
    switch (_selectedOption) {
      case 'Leaves':
        const labels = ['Emp Code', 'CL', 'PL', 'SL', 'Comp Off'];
        return labels[index];
      case 'Email':
        const labels = ['Emp Code', 'Email Id'];
        return labels[index];
      default:
        return '';
    }
  }

  String getHint(int index) {
    switch (_selectedOption) {
      case 'Leaves':
        const labels = [
          'Enter the Emp Code / Emp ID',
          'Casual leaves',
          'Paid Leaves',
          'Sick Leaves',
          'Comp Off',
        ];
        return labels[index];
      case 'Email':
        const labels = ['Enter the Emp Code / Emp ID', 'Email-Address'];
        return labels[index];
      default:
        return '';
    }
  }
}
