import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {'icon': FontAwesomeIcons.moneyBill, 'name': 'Tuition Salary'},
    {'icon': FontAwesomeIcons.mobileScreen, 'name': 'Mobile'},
    {'icon': FontAwesomeIcons.bus, 'name': 'Transport'},
    {'icon': FontAwesomeIcons.internetExplorer, 'name': 'Internet'},
    {'icon': FontAwesomeIcons.bolt, 'name': 'Electricity'},
    {'icon': FontAwesomeIcons.dove, 'name': 'BKash'},
    {'icon': FontAwesomeIcons.buildingColumns, 'name': 'Bank'},
    {'icon': FontAwesomeIcons.shirt, 'name': 'Cloth'},
    {'icon': FontAwesomeIcons.desktop, 'name': 'Accessories'},
    {'icon': FontAwesomeIcons.bagShopping, 'name': 'Shopping'},
    {'icon': FontAwesomeIcons.utensils, 'name': 'Food'},
    {'icon': FontAwesomeIcons.houseMedical, 'name': 'Health'},
    {'icon': FontAwesomeIcons.phone, 'name': 'Phone'},
    {'icon': FontAwesomeIcons.house, 'name': 'Rent'},
    {'icon': FontAwesomeIcons.water, 'name': 'Water'},
    {'icon': FontAwesomeIcons.tv, 'name': 'TV'},
    {'icon': FontAwesomeIcons.gasPump, 'name': 'Gas'},
    {'icon': FontAwesomeIcons.creditCard, 'name': 'Credit Card'},
    {'icon': FontAwesomeIcons.gasPump, 'name': 'Fuel'},
    {'icon': FontAwesomeIcons.soap, 'name': 'Laundry'},
    {'icon': FontAwesomeIcons.basketShopping, 'name': 'Grocery'},
    {'icon': FontAwesomeIcons.pills, 'name': 'Pharmacy'},
    {'icon': FontAwesomeIcons.squareParking, 'name': 'Parking'},
    {'icon': FontAwesomeIcons.taxi, 'name': 'Taxi'},

    {'icon': FontAwesomeIcons.mugSaucer, 'name': 'Cafe'},
    {'icon': FontAwesomeIcons.car, 'name': 'Car Wash'},
    {'icon': FontAwesomeIcons.utensils, 'name': 'Dining'},
    {'icon': FontAwesomeIcons.hotel, 'name': 'Hotel'},
    {'icon': FontAwesomeIcons.houseCrack, 'name': 'Mall'},
    {'icon': FontAwesomeIcons.truck, 'name': 'Shipping'},
  ];

  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpensesCategories.firstWhere(
        (category) => category['name'] == categoryName,
        orElse: () => {'icon': FontAwesomeIcons.solidStar});
    return category['icon'];
  }
}
