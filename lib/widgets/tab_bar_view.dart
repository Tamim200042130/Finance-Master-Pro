import 'package:finance_master_pro/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TypeTapBar extends StatelessWidget {
  const TypeTapBar(
      {super.key, required this.category, required this.monthYear});

  final String category;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              dividerColor: Colors.yellowAccent[700],
              tabs: const [
                Tab(
                  text: 'Income',
                  icon: Icon(
                    FontAwesomeIcons.circleArrowUp,
                    color: Colors.greenAccent,
                    size: 25,
                  ),
                ),
                Tab(
                  text: 'Expense',
                  icon: Icon(
                    FontAwesomeIcons.circleArrowDown,
                    color: Colors.redAccent,
                    size: 25,
                  ),
                ),
              ],
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TransactionList(
                    category: category,
                    type: 'Income',
                    monthYear: monthYear,
                  ),
                  TransactionList(
                    category: category,
                    type: 'Expense',
                    monthYear: monthYear,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
