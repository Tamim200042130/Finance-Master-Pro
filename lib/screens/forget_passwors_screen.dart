import 'package:finance_master_pro/utils/appValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/dissmiss_keyboard_on_tap.dart';
import 'login_screen.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  var appValidator = AppValidator();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim())
            .then((value) => {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFF252634),
                        icon: Icon(FontAwesomeIcons.circleCheck,
                            size: 50, color: Colors.greenAccent),
                        content: Text(
                            "Password reset link is sent. Check your email!!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text('Okay',
                                style: TextStyle(
                                    color: Colors.yellowAccent[700],
                                    fontSize: 20)),
                          ),
                        ],
                      );
                    },
                  )
                });
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFF252634),
              icon: Icon(
                FontAwesomeIcons.circleExclamation,
                size: 50,
                color: Colors.redAccent,
              ),
              content: Text(
                "${e}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Okay',
                      style: TextStyle(
                          color: Colors.yellowAccent[700], fontSize: 20)),
                ),
              ],
            );
          },
        );
      }
    }
    setState(() {
      isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      appBar: AppBar(
        backgroundColor: Color(0xFF252634),
        elevation: 0,
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.circleArrowLeft,
              color: Colors.yellowAccent[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: DismissKeyboardOnTap(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Forget Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter your email address below to receive password reset instructions.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Email', Icons.email),
                    validator: appValidator.validateEmail,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          isLoader ? ' ' : passwordReset();
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
                            : Text('Reset Password',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
            ),
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
