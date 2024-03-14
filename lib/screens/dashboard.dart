import 'package:finance_master_pro/screens/home_screen.dart';
import 'package:finance_master_pro/screens/transaction_screen.dart';
import 'package:finance_master_pro/screens/user_profile.dart';
import 'package:finance_master_pro/widgets/navbar.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var authService = AuthService();
  var isLogoutLoading = false;
  int currentIndex = 0;
  var pageViewList = [HomeScreen(), TransactionScreen(), UserProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (int value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
        body: pageViewList[currentIndex]);
  }
}
