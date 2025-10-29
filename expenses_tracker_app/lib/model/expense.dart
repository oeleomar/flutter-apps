import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.MEd();

final uuid = Uuid();

enum Category { comida, viagem, trabalho, espiritualidade }

const categoryIcons = {
  Category.comida: Icons.lunch_dining,
  Category.viagem: Icons.flight_takeoff,
  Category.trabalho: Icons.work,
  Category.espiritualidade: Icons.mode_night_sharp,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formatedDate {
    return formatter.format(date);
  }
}
