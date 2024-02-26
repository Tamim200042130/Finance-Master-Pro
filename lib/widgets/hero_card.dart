import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeroCard extends StatelessWidget {
  HeroCard({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong',
                    style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
                child: Text(
              'Document does not exist',
              style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          return Cards(
            data: data,
          );
        });
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.data,
  });

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF252634),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Total Balance',
                    style: TextStyle(
                        color: Colors.yellowAccent[700],
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    " ${data['remainingAmount']} ৳",
                    style: TextStyle(
                        color: Colors.yellowAccent[700],
                        fontSize: 40,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Color(0xFF2E3047),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardOne(
                    color: Colors.greenAccent[700]!,
                    heading: 'Income',
                    amount: "${data['totalIncome']}",
                  ),
                  SizedBox(width: 10),
                  CardOne(
                    color: Colors.redAccent[700]!,
                    heading: 'Expense',
                    amount: "${data['totalExpense']}",
                  ),
                ]),
          )
        ],
      ),
    );
  }
}

class CardOne extends StatelessWidget {
  const CardOne({
    super.key,
    required this.color,
    required this.heading,
    required this.amount,
  });

  final Color color;
  final String heading;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${amount} ৳',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  heading == 'Income'
                      ? FontAwesomeIcons.circleArrowUp
                      : FontAwesomeIcons.circleArrowDown,
                  color: heading == 'Income' ? Colors.green : Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
