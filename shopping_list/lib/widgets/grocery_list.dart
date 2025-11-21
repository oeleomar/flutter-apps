import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _onRemoveItem(GroceryItem item) {
    final itemIndex = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text(
          "Item apagado",
        ),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              _groceryItems.insert(itemIndex, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = Center(
      child: Text(
        "Desculpe, nenhum item disponivel!",
      ),
    );

    if (_groceryItems.isNotEmpty) {
      currentWidget = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: Colors.red.withAlpha(200),
          ),
          onDismissed: (direction) {
            _onRemoveItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas lista'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: currentWidget,
    );
  }
}
