import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:promi/login.dart';
import 'package:promi/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(239, 179, 49, 1),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            double fieldWidth = isMobile ? constraints.maxWidth * 0.85 : 400;

            return Center(
              child: Container(
                width: isMobile ? double.infinity : constraints.maxWidth * 0.5,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/Main.json',
                          width: 428, height: 228, fit: BoxFit.fill),
                      Text('Sign Up',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Please sign up to continue.',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      _buildTextField(
                          controller: firstNameController,
                          label: 'First Name',
                          width: fieldWidth),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: lastNameController,
                          label: 'Last Name',
                          width: fieldWidth),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          width: fieldWidth),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: passwordController,
                          label: 'Password',
                          width: fieldWidth,
                          isPassword: true),
                      SizedBox(height: 16),
                      SizedBox(
                        width: fieldWidth,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(2, 46, 6, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async {
                            // // Pass student number and full name to login page
                            // Navigator.of(context).pushReplacement(MaterialPageRoute(
                            //   builder: (BuildContext context) => Login(),
                            // ));
                            await AuthService().signup(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                            );

                            //add user details
                            addUserDetails(
                                firstNameController.text.trim(),
                                lastNameController.text.trim(),
                                emailController.text.trim());
                          },
                          child: Text('Sign Up',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Login()));
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    });
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required double width,
      bool isPassword = false}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
