import 'package:finance_master_pro/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/tab_bar_view.dart';
import '../widgets/time_line_month.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({
    super.key,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
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
      ),
      body: Column(
        children: [
          TimeLineMonth(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  monthYear = value;
                });
              }
            },
          ),
          CategoryList(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  category = value;
                });
              }
            },
          ),
          TypeTapBar(
            category: category,
            monthYear: monthYear,
          ),
        ],
      ),
    );
  }
}
