import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';
import '../widgets/add_transaction.dart';
import '../widgets/dissmiss_keyboard_on_tap.dart';
import '../widgets/hero_card.dart';
import '../widgets/transaction_cards.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var authService = AuthService();
  var isLogoutLoading = false;
  String? userName;




  _dialogAdd(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF252634),
          content: AddTransaction(),
        );
      },
    );
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userName = userData['username'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.greenAccent.shade400,
        backgroundColor: Colors.yellowAccent[700],
        onPressed: () {
          _dialogAdd(context);
        },
        child: const Icon(
          FontAwesomeIcons.circlePlus,
          size: 30,
        ),
      ),
      backgroundColor: Color(0xFF2E3047),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF252634),
        title: Row(
          children: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => UserProfilePage()),
            //     );
            //   },
            //   icon: Icon(
            //     FontAwesomeIcons.solidCircleUser,
            //     color: Colors.yellowAccent[700],
            //     size: 30,
            //   ),
            // ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                userName != null ? 'Welcome, $userName' : 'Home Screen',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: DismissKeyboardOnTap(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HeroCard(
                userId: userId,
              ),
              TransactionsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
