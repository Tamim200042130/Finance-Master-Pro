import 'package:finance_master_pro/screens/sign_up.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/appValidator.dart';
import '../widgets/dissmiss_keyboard_on_tap.dart';
import 'dashboard.dart';
import 'forget_passwors_screen.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var isLoader = false;
  var authService = AuthService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      await authService.login(data, context);

      setState(() {
        isLoader = false;
      });
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: DismissKeyboardOnTap(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text('Login to your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildInputDecoration('Email', Icons.email),
                      validator: appValidator.validateEmail,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildInputDecoration('Password', Icons.lock),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPassword()));
                        },
                        child: Text('Forget Password?',
                            style: TextStyle(
                                color: Colors.yellowAccent[700], fontSize: 18)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            isLoader ? ' ' : _submitForm();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellowAccent[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: isLoader
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.black,
                                ))
                              : Text('Login',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                        )),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text('Create a new account',
                          style: TextStyle(
                              color: Colors.yellowAccent[700], fontSize: 18)),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
        fillColor: Color(0xAA494A59),
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x35949494)),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent[700]!),
            borderRadius: BorderRadius.circular(10)),
        labelStyle: TextStyle(color: Colors.white),
        labelText: labelText,
        suffixIcon: Icon(icon, color: Colors.yellowAccent[700]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  }
}
