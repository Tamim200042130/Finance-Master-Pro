import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionListAll extends StatelessWidget {
  TransactionListAll(
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
        .where('type', isEqualTo: type);

    return FutureBuilder<QuerySnapshot>(
        future: query.limit(150).get(),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: const CircularProgressIndicator(
              color: Colors.yellowAccent,
            ));
          }
          var data = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var cardData = data[index];
              return TransactionCard(
                data: cardData,
              );
            },
          );
        });
  }
}
