import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:provider/provider.dart';

class DashCard extends StatelessWidget {
  final String? text;
  final String? data;
  const DashCard({super.key, required this.text, this.data});

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(top: kToolbarHeight, left: 30),
      child: Container(
        width: width / 7,
        height: height / 8,
        decoration: BoxDecoration(),
        child: Card(
          elevation: 5,
          shadowColor: Colors.black45,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blue.shade700
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text!,
                        style: GoogleFonts.merriweather(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                      data!,
                        style: GoogleFonts.merriweather(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
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
    );
  }
}
