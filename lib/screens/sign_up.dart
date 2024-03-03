import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/appValidator.dart';
import '../widgets/dissmiss_keyboard_on_tap.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _userNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        'username': _userNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'password': _passwordController.text,
        'remainingAmount': 0,
        'totalIncome': 0,
        'totalExpense': 0,
      };
      await authService.createUser(data, context);
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
                      child: Text('Create new Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                        controller: _userNameController,
                        style: TextStyle(color: Colors.white),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            _buildInputDecoration('Username', Icons.person),
                        validator: appValidator.validateUsername),
                    SizedBox(
                      height: 16,
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
                      controller: _phoneNumberController,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          _buildInputDecoration('Phone Number', Icons.phone),
                      validator: appValidator.validatePhoneNumber,
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
                      validator: appValidator.validatePassword,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      style: TextStyle(color: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          _buildInputDecoration('Confirm Password', Icons.lock),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40,
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
                              : Text('Create Account',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                        )),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text('Login',
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
