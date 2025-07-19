import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String btnTxt;
  final Function()? func;
  Color btnColor = Colors.blue.shade800;
  final Color txtColor = Colors.white;
  MyButton({super.key, required this.btnTxt, this.func});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: ElevatedButton(
        onPressed: func,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
          ),
          backgroundColor: WidgetStatePropertyAll(btnColor),
          elevation: WidgetStatePropertyAll(8.r),
          foregroundColor: WidgetStatePropertyAll(txtColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
          ),
        ),
        child: Text(btnTxt, style: GoogleFonts.merriweather(fontSize: 16.sp)),
      ),
    );
  }
}
