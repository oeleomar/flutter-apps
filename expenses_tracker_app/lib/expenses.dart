import 'package:expenses_tracker_app/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker_app/data/dummy_data.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Chart'),
          Expanded(
            child: ExpensesList(expenses: expenses),
          ),
        ],
      ),
    );
  }
}
