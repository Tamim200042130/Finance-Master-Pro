import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  TransactionList(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final String category;
  final String type;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .where('monthyear', isEqualTo: monthYear)
        .where('type', isEqualTo: type);

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: const Text(
              'Something went wrong',
              style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: const CircularProgressIndicator(
            color: Colors.yellowAccent,
          ));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Center(
                child: const Text(
              'You Have No Transactions',
              style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            )),
          );
        }

        var data = snapshot.data!.docs;
        double totalAmount = 0.0;

        for (var doc in data) {
          totalAmount += doc['amount'];
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                type == 'Income'
                    ? 'Total Income: ${totalAmount.toStringAsFixed(0)} \৳'
                    : 'Total Expense: ${totalAmount.toStringAsFixed(0)} \৳',
                style: TextStyle(
                    color: type == 'Income' ? Colors.green : Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var cardData = data[index];
                  return TransactionCard(
                    data: cardData,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
