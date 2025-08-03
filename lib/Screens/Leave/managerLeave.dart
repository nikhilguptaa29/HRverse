import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Models/leaveRequestModel.dart';
import 'package:hrverse/Provider/leaveProvider.dart';
import 'package:provider/provider.dart';

class ManagerLeave extends StatefulWidget {
  const ManagerLeave({super.key});

  @override
  State<ManagerLeave> createState() => _ManagerLeaveState();
}

class _ManagerLeaveState extends State<ManagerLeave> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String mngrId = '';

  void fetchManagerId() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final id = await _firestore.collection("Employees").doc(userId).get();

    setState(() {
      mngrId = id.get('empCode');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchManagerId();
  }

  @override
  Widget build(BuildContext context) {
    print("Manager Id is :- ${mngrId}");
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<Leaverequest>>(
        stream: leaveProvider.fetchPendingManager(mngrId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Pending Leaves.. You good to go"));
          }

          final request = snapshot.data!;

          return ListView.builder(
            itemBuilder: (context, index) {
              final req = request[index];

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Employee : ${req.empName}",
                        style: GoogleFonts.merriweather(fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "From : ${req.startDate}",
                        style: GoogleFonts.merriweather(fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "To : ${req.endDate}",
                        style: GoogleFonts.merriweather(fontSize: 14),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              );
            },
            itemCount: request.length,
          );
        },
      ),
    );
  }
}
