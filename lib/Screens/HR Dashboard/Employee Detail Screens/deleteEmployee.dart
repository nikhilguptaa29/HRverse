import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Utils/Widgets/empButton.dart';
import 'package:provider/provider.dart';

class DeleteEmployee extends StatefulWidget {
  const DeleteEmployee({super.key});

  @override
  State<DeleteEmployee> createState() => _DeleteEmployeeState();
}

class _DeleteEmployeeState extends State<DeleteEmployee> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context);
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.only(
            top: kToolbarHeight + 10,
            left: 20,
            right: 20,
            bottom: kToolbarHeight,
          ),
          child: Container(
            width: width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 1.5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: kToolbarHeight - 10),
                  child: Text(
                    "Delete Employee",
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight,
                    bottom: kToolbarHeight,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: kToolbarHeight - 50),
                        child: SizedBox(
                          width: 200,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Emp Code / Emp Id",
                              labelText: "Emp Code",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: kToolbarHeight - 50),
                        child: EmpButton(
                          btnTxt: "Delete",
                          func: () async {
                            final result = await authProvider.deleteUser(
                              searchController.text,
                            );

                            if (result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("User deleted Successfully"),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Sorry we are unable to delete the User at this moment of time",
                                  ),
                                ),
                              );
                            }
                          },
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
