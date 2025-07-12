import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/empButton.dart';
import 'package:hrverse/Utils/Widgets/employeeTextForm.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final Authservices _auth = Authservices();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController managerController = TextEditingController();
  TextEditingController managermailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController plController = TextEditingController();
  TextEditingController clController = TextEditingController();
  TextEditingController slController = TextEditingController();
  // TextEditingController compController = TextEditingController();
  String roleSelected = '';
  List<String> role = ['Employee', 'HR', 'Manager'];
  String genderSelected = '';
  List<String> gender = ['Male', 'Female'];

  void userCreate() async {
    bool result = await _auth.createEmployee(
      idController.text,
      nameController.text,
      emailController.text,
      roleSelected,
      genderSelected,
      designationController.text,
      managerController.text,
      managermailController.text,
      dobController.text,
      clController.text,
      plController.text,
      "0",
      "0",
    );

    if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("User Created Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to creat user.... Try Again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + 10,
            left: 20,
            right: 20,
            bottom: kBottomNavigationBarHeight,
          ),
          child: Container(
            width: width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight - 10),
                  child: Text(
                    "Add Employee",
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 25,
                    ),
                    child: GridView.count(
                      childAspectRatio: 9.5,
                      mainAxisSpacing: 25,
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      shrinkWrap: true,
                      children: [
                        EmpTextForm(
                          hntTxt: "Enter Emp Code",
                          lblTxt: 'Emp Code',
                          isPass: false,
                          controller: idController,
                          type: TextInputType.number,
                        ),
                        EmpTextForm(
                          hntTxt: "Enter Name",
                          lblTxt: 'Name',
                          isPass: false,
                          controller: nameController,
                          type: TextInputType.text,
                        ),
                        EmpTextForm(
                          hntTxt: "Enter Designation",
                          lblTxt: 'Designation',
                          isPass: false,
                          controller: designationController,
                          type: TextInputType.text,
                        ),
                        EmpTextForm(
                          hntTxt: "Enter Email",
                          lblTxt: 'Email',
                          isPass: false,
                          controller: emailController,
                          type: TextInputType.emailAddress,
                        ),
                        EmpTextForm(
                          hntTxt: "Enter DOB",
                          lblTxt: 'DOB',
                          isPass: false,
                          controller: dobController,
                          type: TextInputType.datetime,
                        ),
                        EmpTextForm(
                          hntTxt: "Reporting Manager",
                          lblTxt: 'Manager',
                          isPass: false,
                          controller: managerController,
                          type: TextInputType.text,
                        ),
                        EmpTextForm(
                          hntTxt: "Reporting Manager Mail",
                          lblTxt: 'Manager Mail',
                          isPass: false,
                          controller: managermailController,
                          type: TextInputType.emailAddress,
                        ),
                        DropdownButtonFormField(
                          // value: genderSelected,
                          hint: Text("Select Gender"),
                          items:
                              gender.map((genders) {
                                return DropdownMenuItem(
                                  child: Text(genders),
                                  value: genders,
                                );
                              }).toList(),
                          onChanged: (String? newVal) {
                            genderSelected = newVal!;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        DropdownButtonFormField(
                          hint: Text("Select Role"),
                          items:
                              role.map((roles) {
                                return DropdownMenuItem(
                                  child: Text(roles),
                                  value: roles,
                                );
                              }).toList(),
                          onChanged: (String? newVal) {
                            roleSelected = newVal!;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        EmpTextForm(
                          hntTxt: "CL",
                          lblTxt: 'Casual Leaves',
                          isPass: false,
                          controller: clController,
                          type: TextInputType.number,
                        ),
                        EmpTextForm(
                          hntTxt: "PL",
                          lblTxt: 'Paid Leaves',
                          isPass: false,
                          controller: plController,
                          type: TextInputType.number,
                        ),
                        EmpTextForm(
                          hntTxt: "SL",
                          lblTxt: 'Sick Leaves',
                          isPass: false,
                          controller: slController,
                          type: TextInputType.number,
                        ),

                        // EmpTextForm(
                        //   hntTxt: "Comp Off",
                        //   lblTxt: 'Comp Off',
                        //   isPass: false,
                        //   controller: compController,
                        //   type: TextInputType.number,
                        // ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmpButton(
                        btnTxt: "Create User",
                        func: () {
                          userCreate();
                        },
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
