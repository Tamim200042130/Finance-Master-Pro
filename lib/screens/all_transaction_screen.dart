
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/tab_bar_view_all.dart';
import 'dashboard.dart';

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
                ),
          ),
        ),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.circleArrowLeft,
              size: 30,
              color: Colors.yellowAccent[700]),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Dashboard()),
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
