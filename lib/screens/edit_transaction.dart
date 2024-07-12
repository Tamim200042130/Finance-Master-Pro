import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/utils/appValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/category_dropdown.dart';
import '../widgets/dissmiss_keyboard_on_tap.dart';
import 'dashboard.dart';

class EditTransaction extends StatefulWidget {
  final Map<String, dynamic> transactionData;

  const EditTransaction({Key? key, required this.transactionData})
      : super(key: key);

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  var isLoader = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var amountEditingController = TextEditingController();
  var titleEditingController = TextEditingController();
  var typeEditingController = TextEditingController();
  var category = 'Tuition Salary';
  var type = 'Income';
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    titleEditingController.text = widget.transactionData['title'];
    category = widget.transactionData['category'];
    amountEditingController.text = widget.transactionData['amount'].toString();
    type = widget.transactionData['type'];
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      final transactionId = widget.transactionData['id'];
      final updatedTitle = titleEditingController.text;
      final updatedCategory = category;
      final updatedAmount = amountEditingController.text;
      final updatedType = type;

      try {
        final userDocSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (!userDocSnapshot.exists) {
          throw Exception("User document does not exist");
        }

        int totalIncome = userDocSnapshot['totalIncome'] ?? 0;
        int totalExpense = userDocSnapshot['totalExpense'] ?? 0;
        int remainingAmount = userDocSnapshot['remainingAmount'] ?? 0;

        // Convert the original amount to an integer
        double originalAmountDouble = double.parse(widget.transactionData['amount'].toString());
        int originalAmount = originalAmountDouble.toInt();

        // Convert the updated amount to an integer
        double newAmountDouble = double.parse(updatedAmount);
        int newAmount = newAmountDouble.toInt();

        // Undo the original amount based on the original type
        if (widget.transactionData['type'] == 'Income') {
          totalIncome -= originalAmount;
          remainingAmount -= originalAmount;
        } else {
          totalExpense -= originalAmount;
          remainingAmount += originalAmount;
        }

        // Apply the new amount based on the updated type
        if (updatedType == 'Income') {
          totalIncome += newAmount;
          remainingAmount += newAmount;
        } else {
          totalExpense += newAmount;
          remainingAmount -= newAmount;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .doc(transactionId)
            .update({
          'title': updatedTitle,
          'category': updatedCategory,
          'amount': newAmountDouble, // Store the updated amount as double
          'type': updatedType,
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'totalIncome': totalIncome,
          'totalExpense': totalExpense,
          'remainingAmount': remainingAmount,
          'updatedAt': timestamp,
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
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



  Future<void> _deleteTransaction() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final transactionId = widget.transactionData['id'];
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (!userDocSnapshot.exists) {
        throw Exception("User document does not exist");
      }

      int totalIncome = userDocSnapshot['totalIncome'] ?? 0;
      int totalExpense = userDocSnapshot['totalExpense'] ?? 0;
      int remainingAmount = userDocSnapshot['remainingAmount'] ?? 0;

      int originalAmount = (widget.transactionData['amount'] is int)
          ? widget.transactionData['amount'] as int
          : (widget.transactionData['amount'] as double).toInt();

      if (widget.transactionData['type'] == 'Income') {
        totalIncome -= originalAmount;
        remainingAmount -= originalAmount;
      } else {
        totalExpense -= originalAmount;
        remainingAmount += originalAmount;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transactionId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'remainingAmount': remainingAmount,
        'updatedAt': timestamp,
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
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
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Try Again',
                  style:
                  TextStyle(color: Colors.yellowAccent[700], fontSize: 20),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var appValidator = AppValidator();
    return DismissKeyboardOnTap(
      child: Scaffold(
        backgroundColor: Color(0xFF252634),
        appBar: AppBar(
          backgroundColor: Color(0xFF252634),
          title: Center(
            child: Text(
              'Edit Transaction',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.circleArrowLeft,
                size: 30, color: Colors.yellowAccent[700]),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.solidTrashCan,
                size: 24,
                color: Colors.yellowAccent[700],
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF252634),
                      title: Text(
                        'Confirm Deletion',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent.shade200,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to delete this transaction?',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.yellowAccent[700],
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteTransaction();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.redAccent.shade200,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30),
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
                  TextFormField(
                    controller: amountEditingController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration(
                        'Amount', FontAwesomeIcons.dollarSign),
                    validator: appValidator.validateAmount,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  }
}
