import 'package:flutter/material.dart';

class EmpButton extends StatelessWidget {
  final String btnTxt;
  final Function()? func;
  final Color btnColor = Colors.blue;
  final Color txtColor = Colors.white;
  const EmpButton({super.key, required this.btnTxt, this.func});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ElevatedButton(
        child: Text(btnTxt),
        onPressed: func,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 25,vertical: 10)),
          backgroundColor: WidgetStatePropertyAll(btnColor),
          elevation: WidgetStatePropertyAll(5),
          foregroundColor: WidgetStatePropertyAll(txtColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}
