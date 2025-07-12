import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/dashCard.dart';
import 'package:provider/provider.dart';

class MainDash extends StatefulWidget {
  const MainDash({super.key});

  @override
  State<MainDash> createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userCount();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Authprovider>(context,listen: false).userCount();
    });
  }

  int? _userCount;
  bool _isLoading = false;

  // Future<void> userCount() async {
  //   try {
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('Employees').get();
  //     setState(() {
  //       _userCount = snapshot.docs.length;
  //       _isLoading = true;
  //     });
  //   } catch (e) {
  //     print("Error : $e");
  //     setState(() {
  //       _isLoading = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: true);
    final Authservices authservices = Authservices();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              DashCard(text: 'Total Employees',data: '${authProvider.count}',)
            ],
          ),
        ],
      ),
    );
  }
}
