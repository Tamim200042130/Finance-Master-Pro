import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/screens/all_transaction_screen.dart';
import 'package:finance_master_pro/utils/icons_list.dart';
import 'package:finance_master_pro/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text("Recent Transactions",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.w600)),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => AllTransactionScreen()),
                  );
                },
                child: Text("See All",
                    style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          SizedBox(height: 10),
          RecentTransactionList()
        ],
      ),
    );
  }
}

class RecentTransactionList extends StatelessWidget {
  RecentTransactionList({
    super.key,
  });

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .limit(4)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: const Text('Something went wrong',
                    style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)));
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
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
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
