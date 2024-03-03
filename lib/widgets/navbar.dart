import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  NavBar(
      {super.key,
      required this.selectedIndex,
      required this.onDestinationSelected});

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor:Color(0xFF252634),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: Colors.yellowAccent[700],
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      height: 65,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home_rounded,color: Colors.white,size: 30,),
          selectedIcon: Icon(Icons.home_rounded,color: Colors.black,size: 30,),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_rounded,color: Colors.white,size: 30,),
          selectedIcon: Icon(Icons.account_balance_wallet_rounded,color: Colors.black,size: 30,),
          label: 'Transactions',
        ),

      ],
    );
  }
}
