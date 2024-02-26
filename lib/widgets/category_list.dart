import 'package:finance_master_pro/utils/icons_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = '';
  List<Map<String, dynamic>> categoryList = [];
  final scrollController = ScrollController();
  var appIcon = AppIcons();
  var addCat = {'name': 'All', 'icon': FontAwesomeIcons.listAlt};

  @override
  void initState() {
    super.initState();

    setState(() {
      categoryList = appIcon.homeExpensesCategories;
      categoryList.insert(0, addCat);
      currentCategory = 'All';
    });

    Future.delayed(Duration(milliseconds: 300), scrollToSelectedCategory);
  }


  void scrollToSelectedCategory() {
    final selectedCategoryIndex =
        categoryList.indexWhere((item) => item['name'] == 'All');
    if (selectedCategoryIndex != -1) {
      final scrollOffset = (selectedCategoryIndex * 100.0) - 170;
      scrollController.animateTo(scrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
          controller: scrollController,
          itemCount: categoryList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var data = categoryList[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentCategory = data['name'];
                  widget.onChanged(data['name']);
                });
              },
              child: Container(
                  width: 150,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: currentCategory == data['name']
                        ? Colors.yellowAccent[700]!
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(data['icon'], color: Colors.black, size: 25),
                      SizedBox(width: 10),
                      Text(data['name'],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ],
                  ))),
            );
          }),
    );
  }
}
