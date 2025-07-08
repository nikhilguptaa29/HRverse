import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Hr",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  foreground:
                      Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ).createShader(Rect.fromLTWH(70, 0, 200, 70)),
                ),
              ),
              TextSpan(
                text: "Verse",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,
                foreground:
                  Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ).createShader(Rect.fromLTWH(70, 0, 200, 70)),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
