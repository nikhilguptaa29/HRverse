import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Provider/authProvider.dart';
import 'package:hrverse/Provider/dropdownProvider.dart';
import 'package:hrverse/Provider/updateProvider.dart';
import 'package:hrverse/Utils/Widgets/empButton.dart';
import 'package:provider/provider.dart';

class UpdateEmployee extends StatefulWidget {
  const UpdateEmployee({super.key});

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  final List<String> options = ['Leaves', 'Email'];

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
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight - 10),
                  child: Text(
                    "Update Employee",
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: kToolbarHeight,
                    bottom: kToolbarHeight,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: kToolbarHeight - 50,
                          ),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: kToolbarHeight - 50,
                        ),
                        child: EmpButton(
                          btnTxt: 'Search',
                          func: () {
                            final userId = searchController.text.trim();

                            if (userId.isNotEmpty) {
                              authProvider.userDetail(userId);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer3<
                    Authprovider,
                    Dropdownprovider,
                    Updateprovider
                  >(
                    builder: (ctx, auth, dropdown, formProvider, _) {
                      if (!auth.isUserDetailFetch) {
                        return SizedBox(
                          child: Center(child: Text("Data not Extracted")),
                        );
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (formProvider.controllers.length !=
                              dropdown.textFieldCount) {
                            formProvider.initializeController(
                              dropdown.textFieldCount,
                            );
                          }
                        });
                        if (formProvider.controllers.length !=
                            dropdown.textFieldCount) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 100,
                                child: DropdownButtonFormField(
                                  items:
                                      options.map((item) {
                                        return DropdownMenuItem(
                                          child: Text(item),
                                          value: item,
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      dropdown.selectOption = value;
                                      formProvider.clearControllers();
                                      formProvider.initializeController(
                                        dropdown.textFieldCount,
                                      );
                                    }
                                  },
                                  // value: dropdown.selectOption,
                                  hint: Text("Select"),
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
                              ),
                              const SizedBox(height: 20),
                              ...List.generate(dropdown.textFieldCount, (
                                index,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: TextField(
                                    controller: formProvider.controllers[index],
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      labelText: dropdown.getLabel(index),
                                      hintText: dropdown.getHint(index),
                                    ),
                                  ),
                                );
                              }),
                              EmpButton(
                                btnTxt: "Update",
                                func: () async {
                                  final empCode =
                                      formProvider.controllers[0].text.trim();
                                  bool result = await formProvider.updateUser(
                                    empCode,
                                    dropdown.selectOption,
                                  );

                                  if (result) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Updated Successfully....",
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Can't Update Right now....",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
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
