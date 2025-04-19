import 'package:flutter/material.dart';
import 'package:promi/home.dart';
import 'package:promi/services/auth_service.dart';
import 'package:promi/signup.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isWideScreen = size.width > 600;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 100 : 20),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 179, 49, 1),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/Main.json',
              width: 428,
              height: 228,
              fit: BoxFit.fill
          ),
              const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Please Sign in to continue.', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              _buildTextField(controller: emailController, label: 'Email', isEmail: true),
              const SizedBox(height: 10),
              _buildTextField(controller: passwordController, label: 'Password', isPassword: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    // if (_formKey.currentState!.validate()) {
                    //   Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //       builder: (BuildContext context) => Home(),
                    //     ),
                    //   );
                    // }
                    await AuthService().signin(
                      email: emailController.text, 
                      password: passwordController.text, 
                      context: context
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(2, 46, 6, 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) => Signup()));
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
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
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        if (isEmail && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }
}