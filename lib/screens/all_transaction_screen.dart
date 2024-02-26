import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/transaction_list_all.dart';
import '../widgets/tab_bar_view.dart';
import '../widgets/transaction_card.dart';
import '../widgets/type_bar_all.dart';

class AllTransactionScreen extends StatefulWidget {
  const AllTransactionScreen({
    super.key,
  });

  @override
  State<AllTransactionScreen> createState() => _AllTransactionScreenState();
}

class _AllTransactionScreenState extends State<AllTransactionScreen> {
  var category = 'All';
  var monthYear = '';

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    var formatter = DateFormat('MMMM-yyyy');
    monthYear = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252634),
      appBar: AppBar(
        backgroundColor: const Color(0xFF252634),
        title: Center(
          child: const Text(
            'Transactions',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.2),
          ),
        ),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.circleArrowLeft,
              color: Colors.yellowAccent[700]),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          TypeTapBarAll(
            category: category,
            monthYear: monthYear,
          ),
        ],
      ),
    );
  }
}
