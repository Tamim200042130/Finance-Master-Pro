import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {'icon': FontAwesomeIcons.moneyBill, 'name': 'Tuition Salary'},
    {'icon': FontAwesomeIcons.bus, 'name': 'Transport'},
    {'icon': FontAwesomeIcons.home, 'name': 'Rent'},
    {'icon': FontAwesomeIcons.bolt, 'name': 'Electricity'},
    {'icon': FontAwesomeIcons.water, 'name': 'Water'},
    {'icon': FontAwesomeIcons.internetExplorer, 'name': 'Internet'},
    {'icon': FontAwesomeIcons.mobileAlt, 'name': 'Mobile'},
    {'icon': FontAwesomeIcons.tv, 'name': 'TV'},
    {'icon': FontAwesomeIcons.gasPump, 'name': 'Gas'},
    {'icon': FontAwesomeIcons.heartbeat, 'name': 'Health'},
    {'icon': FontAwesomeIcons.shoppingBag, 'name': 'Shopping'},
    {'icon': FontAwesomeIcons.utensils, 'name': 'Food'},
    {'icon': FontAwesomeIcons.houseMedical, 'name': 'Health'},
    {'icon': FontAwesomeIcons.creditCard, 'name': 'Credit Card'},
    {'icon': FontAwesomeIcons.shoppingCart, 'name': 'Shopping'},
    {'icon': FontAwesomeIcons.gasPump, 'name': 'Fuel'},
    {'icon': FontAwesomeIcons.soap, 'name': 'Laundry'},
    {'icon': FontAwesomeIcons.film, 'name': 'Entertainment'},
    {'icon': FontAwesomeIcons.shoppingBasket, 'name': 'Grocery'},
    {'icon': FontAwesomeIcons.pills, 'name': 'Pharmacy'},
    {'icon': FontAwesomeIcons.parking, 'name': 'Parking'},
    {'icon': FontAwesomeIcons.taxi, 'name': 'Taxi'},
    {'icon': FontAwesomeIcons.creditCard, 'name': 'ATM'},
    {'icon': FontAwesomeIcons.glassMartini, 'name': 'Bar'},
    {'icon': FontAwesomeIcons.coffee, 'name': 'Cafe'},
    {'icon': FontAwesomeIcons.car, 'name': 'Car Wash'},
    {'icon': FontAwesomeIcons.utensils, 'name': 'Dining'},
    {'icon': FontAwesomeIcons.glassCheers, 'name': 'Drink'},
    {'icon': FontAwesomeIcons.amilia, 'name': 'Florist'},
    {'icon': FontAwesomeIcons.hotel, 'name': 'Hotel'},
    {'icon': FontAwesomeIcons.houseCrack, 'name': 'Mall'},
    {'icon': FontAwesomeIcons.truck, 'name': 'Shipping'},
    {'icon': FontAwesomeIcons.phone, 'name': 'Phone'}
  ];

  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpensesCategories.firstWhere(
        (category) => category['name'] == categoryName,
        orElse: () => {'icon': FontAwesomeIcons.solidStar});
    return category['icon'];
  }
}
