import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../screens/transaction_details_screen.dart';
import '../utils/icons_list.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final dynamic data;
  final appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formattedDate = DateFormat('d MMM yyyy hh:mm a').format(date);

    Color backgroundColor = data['type'] == 'Income'
        ? Colors.greenAccent[700]!
        : Colors.redAccent[700]!;

    return GestureDetector(
      onTap: () {
        // Navigate to the transaction details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetails(data: data),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor.withOpacity(0.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withOpacity(0.1),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ListTile(
            minVerticalPadding: 10,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            leading: Container(
              width: 70,
              height: 100,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.yellowAccent[700],
                ),
                child: Center(
                  child: FaIcon(
                    appIcons.getExpenseCategoryIcons('${data['category']}'),
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "${data['category']}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  "${data['type'] == 'Income' ? '+' : '-'} ${data['amount'] % 1 == 0 ? data['amount'].toInt() : data['amount']} ৳ ",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Text(
                      "${data['remainingAmount']} ৳ ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
