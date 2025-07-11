import 'package:flutter/material.dart';

class HrDash extends StatefulWidget {
  const HrDash({super.key});

  @override
  State<HrDash> createState() => _HrDashState();
}

class _HrDashState extends State<HrDash> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      // width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      // padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.black),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "data",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.amber),
                    ),
                    flex: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
