import 'package:finance_master_pro/widgets/transaction_list_all.dart';
import 'package:flutter/material.dart';

class TypeTapBarAll extends StatelessWidget {
  const TypeTapBarAll(
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
                    Icons.arrow_circle_up_outlined,
                    color: Colors.greenAccent,
                    size: 25,
                  ),
                ),
                Tab(
                  text: 'Expense',
                  icon: Icon(
                    Icons.arrow_circle_down_outlined,
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
                  TransactionListAll(
                    category: category,
                    type: 'Income',
                    monthYear: monthYear,
                  ),
                  TransactionListAll(
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
