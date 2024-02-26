import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/icons_list.dart';

class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({Key? key, this.categoryType, required this.onChanged})
      : super(key: key);

  final String? categoryType;
  final ValueChanged<String?> onChanged;
  final AppIcons appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    final bool othersExists = appIcons.homeExpensesCategories
        .any((category) => category['name'] == 'Others');

    final List<Map<String, dynamic>> dropdownItems = appIcons
        .homeExpensesCategories
        .where((category) => category['name'] != 'Others')
        .toList();

    if (!othersExists) {
      dropdownItems.add({'icon': FontAwesomeIcons.solidStar, 'name': 'Others'});
    }

    return DropdownButtonFormField<String>(
      value: categoryType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFF252634),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x35949494)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent[700]!),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dropdownColor: Color(0xFF252634),
      isExpanded: true,
      hint: Text('Select Category', style: TextStyle(color: Colors.white)),
      icon: Icon(
        FontAwesomeIcons.caretDown,
        color: Colors.yellowAccent[700],
        size: 20,
      ),
      iconEnabledColor: Colors.yellowAccent[700],
      items: dropdownItems
          .map((e) => DropdownMenuItem<String>(
                value: e['name'],
                child: Row(
                  children: [
                    Icon(
                      e['icon'],
                      color: Colors.yellowAccent[700],
                    ),
                    SizedBox(width: 40),
                    Text(
                      e['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
