import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_master_pro/widgets/add_transaction.dart';
import 'package:finance_master_pro/widgets/transaction_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';
import '../widgets/dissmiss_keyboard_on_tap.dart';
import '../widgets/hero_card.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var authService = AuthService();
  var isLogoutLoading = false;
  String? userName;

  _dialogLogout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF252634),
          title: const Text('Are you sure?',
              style: TextStyle(color: Colors.white)),
          content: const Text('Do you want to logout?',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 20)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLogoutLoading = true;
                });
                authService.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()),
                );
                setState(() {
                  isLogoutLoading = false;
                });
              },
              child: const Text('Logout',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

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
        title: Text(
          userName != null ? 'Welcome, $userName' : 'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              _dialogLogout(context);
            },
            icon: isLogoutLoading
                ? CircularProgressIndicator()
                : Icon(
                    FontAwesomeIcons.rightFromBracket,
                    color: Colors.yellowAccent[700],
                    size: 30,
                  ),
          ),
          SizedBox(width: 10)
        ],
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
