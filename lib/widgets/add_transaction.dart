import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/utils/appValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'category_dropdown.dart';
import 'dissmiss_keyboard_on_tap.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  var type = 'Income';
  var category = 'Tuition Salary';
  var isLoader = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var amountEditingController = TextEditingController();
  var titleEditingController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = double.parse(amountEditingController.text);
      DateTime date = DateTime.now();
      var id = uid.v4();
      String monthyear = DateFormat('MMM yyyy').format(date);

      try {
        final userDocSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (!userDocSnapshot.exists) {
          throw Exception("User document does not exist");
        }

        double remainingAmount =
            (userDocSnapshot['remainingAmount'] ?? 0).toDouble();
        double totalIncome = (userDocSnapshot['totalIncome'] ?? 0).toDouble();
        double totalExpense = (userDocSnapshot['totalExpense'] ?? 0).toDouble();

        if (type == 'Income') {
          remainingAmount += amount;
          totalIncome += amount;
        } else {
          remainingAmount -= amount;
          totalExpense += amount;
        }


        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'remainingAmount': remainingAmount.toInt(),
          'totalIncome': totalIncome.toInt(),
          'totalExpense': totalExpense.toInt(),
          'updateAt': timestamp,
        });

        var data = {
          'id': id,
          'title': titleEditingController.text,
          'amount': amount,
          'category': category,
          'type': type,
          'monthyear': monthyear,
          'timestamp': timestamp,
          'totalIncome': totalIncome.toInt(),
          'totalExpense': totalExpense.toInt(),
          'remainingAmount': remainingAmount.toInt(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .doc(id)
            .set(data);

        Navigator.of(context).pop();
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFF252634),
              title: Text('Error',
                  style: TextStyle(
                      color: Colors.redAccent.shade400,
                      fontWeight: FontWeight.w600)),
              content: Text('An error occurred: $error',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Try Again',
                      style: TextStyle(
                          color: Colors.yellowAccent[700],
                          fontWeight: FontWeight.w600)),
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
  Widget build(BuildContext context) {
    var appValidator = AppValidator();
    return DismissKeyboardOnTap(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleEditingController,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration:
                    _buildInputDecoration('Title', FontAwesomeIcons.pencil),
                validator: appValidator.validateTitle,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: amountEditingController,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildInputDecoration(
                    'Amount', FontAwesomeIcons.sackDollar),
                validator: appValidator.validateAmount,
              ),
              SizedBox(height: 16),
              CategoryDropdown(
                categoryType: category,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: type,
                items: const [
                  DropdownMenuItem(
                    value: 'Income',
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.circleArrowUp,
                            color: Colors.lightGreenAccent),
                        SizedBox(width: 40),
                        // Spacer
                        Text('Income',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Expense',
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.circleArrowDown,
                            color: Colors.redAccent),
                        SizedBox(width: 40),
                        // Spacer
                        Text('Expense',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value.toString();
                    });
                  }
                },
                style: TextStyle(color: Colors.white),
                icon: Icon(
                  FontAwesomeIcons.caretDown,
                  color: Colors.yellowAccent[700],
                  size: 20,
                ),
                iconEnabledColor: Colors.yellowAccent[700],
                dropdownColor: Color(0xFF252634),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF252634),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x35949494)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellowAccent[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Color(0xFF949494)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (isLoader == false) {
                    _submitForm();
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
                        'Add Transaction',
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  }
}
