import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrverse/Services/Auth/authServices.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:hrverse/Utils/Widgets/textform.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String roleSelected = '';
  List<String> role = ['Employee', 'HR', 'Manager'];
  String genderSelected = '';
  List<String> gender = ['Male', 'Female'];
  final Authservices _auth = Authservices();

  void signup() async {
    await _auth.signup(
      emailController.text,
      passController.text,
      roleSelected,
      nameController.text,
      genderSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("Assets/Lottie/signup.json", height: 175),
              SizedBox(height: 20),
              Text(
                "Sign Up",
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              MyTextForm(
                hntTxt: 'Name',
                lblTxt: "Name",
                isPass: false,
                controller: nameController,
                type: TextInputType.name,
              ),
              MyTextForm(
                hntTxt: 'Email-Address',
                lblTxt: "Email",
                isPass: false,
                controller: emailController,
                type: TextInputType.emailAddress,
              ),
              MyTextForm(
                hntTxt: 'Password',
                lblTxt: "Password",
                isPass: true,
                controller: passController,
                type: TextInputType.text,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 8,
                ),
                child: DropdownButtonFormField(
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
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 8,
                ),
                child: DropdownButtonFormField(
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
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                  ),
                ),
              ),
              MyButton(
                btnTxt: "Sign Up",
                func: () {
                  signup();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
