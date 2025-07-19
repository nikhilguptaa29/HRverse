import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/attendanceProvider.dart';
import 'package:provider/provider.dart';

class CheckCard extends StatelessWidget {
  final String text;

  const CheckCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: true,
    );
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 2.5.w),
      child: Column(
        children: [
          Container(
            width: 0.48.sw,
            height: 0.17.sh,
            decoration: BoxDecoration(),
            child: Card(
              margin: EdgeInsets.only(left: 5.w, top: 10.h),
              elevation: 8,
              shape: BeveledRectangleBorder(),
              shadowColor: Colors.black,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(width: 2.5.w, color: Colors.blue),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 5.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            text,
                            style: GoogleFonts.poppins(
                              fontSize: (18.sp),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 8.0.w,
                        top: 40.0.h,
                        left: 4.w,
                        bottom: 0.1.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            attendanceProvider.date,
                            style: GoogleFonts.merriweather(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            text == "Check In"
                                ? attendanceProvider.checkInTime
                                : attendanceProvider.checkOutTime,
                            style: GoogleFonts.merriweather(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
