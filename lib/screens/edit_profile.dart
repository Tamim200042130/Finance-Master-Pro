import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/widgets/dissmiss_keyboard_on_tap.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/appValidator.dart';
import 'dashboard.dart';

class EditProfilePage extends StatefulWidget {
  final DocumentSnapshot userDoc;

  const EditProfilePage({required this.userDoc});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _usernameController;

  var appValidator = AppValidator();
  var isLoader = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userDoc.id)
            .update({
          'phoneNumber': _phoneNumberController.text,
          'username': _usernameController.text,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFF252634),
              title: Text(
                'Success',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                ),
              ),
              content: Text(
                'Profile updated successfully!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.yellowAccent[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ],
            );
          },
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFF252634),
              title: Text(
                'Error',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent.shade400),
              ),
              content: Text(
                'An error occurred: $error',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Try Again',
                    style: TextStyle(color: Colors.yellowAccent[700]),
                  ),
                ),
              ],
            );
          },
        );
      }
      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController =
        TextEditingController(text: widget.userDoc['phoneNumber']);
    _usernameController =
        TextEditingController(text: widget.userDoc['username']);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardOnTap(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF252634),
          title: Center(
            child: Text(
              'Edit Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.circleArrowLeft,
                color: Colors.yellowAccent[700]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Color(0xFF252634),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneNumberController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration(
                        'Phone Number', FontAwesomeIcons.phone),
                    validator: appValidator.validatePhoneNumber,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration(
                        'Username', FontAwesomeIcons.pencil),
                    validator: appValidator.validateUsername,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (isLoader == false) {
                        _updateUserProfile();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.yellowAccent[700]!),
                    ),
                    child: isLoader
                        ? Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                  ),
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
      fillColor: Color(0xFF252634),
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x35949494)),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent[700]!),
          borderRadius: BorderRadius.circular(10)),
      labelStyle: TextStyle(color: Colors.white),
      labelText: labelText,
      suffixIcon: Icon(
        icon,
        color: Colors.yellowAccent[700],
        size: 20,
      ),
    );
  }
}
