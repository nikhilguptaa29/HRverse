import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextForm extends StatelessWidget {
  final String hntTxt;
  final String lblTxt;
  final bool isPass;
  final TextEditingController controller;
  final double rad = 15.0;
  final TextInputType type;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  const MyTextForm({
    super.key,
    required this.hntTxt,
    required this.lblTxt,
    required this.isPass,
    required this.controller,
    required this.type,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45.w, vertical: 8.h),
      child: TextFormField(
        controller: controller,
        obscureText: isPass,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hntTxt,
          labelText: lblTxt,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(rad.r)),
            borderSide: BorderSide(color: Colors.blue, width: 1.5.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(rad.r)),
            borderSide: BorderSide(color: Colors.blue, width: 1.5.w),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(rad.r)),
            borderSide: BorderSide(color: Colors.blue, width: 1.5.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(rad.r)),
            borderSide: BorderSide(color: Colors.red, width: 1.5.w),
          ),
        ),
      ),
    );
  }
}
