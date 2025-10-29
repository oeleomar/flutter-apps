import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  /* String _enteredTitle = '';

  void _saveTitleInput(String inputTitle) {
    _enteredTitle = inputTitle;
  } */

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(label: Text('Nome')),
          ),
          TextField(
            controller: _amountController,
            maxLength: 50,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: '\$ ',
              label: Text('Valor'),
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Salvar Despesa'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
