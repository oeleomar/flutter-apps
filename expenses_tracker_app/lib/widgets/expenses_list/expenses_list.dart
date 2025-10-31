import 'package:expenses_tracker_app/model/expense.dart';
import 'package:expenses_tracker_app/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final void Function(Expense expense) onRemoveExpense;

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        key: ValueKey(expenses[index]),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
