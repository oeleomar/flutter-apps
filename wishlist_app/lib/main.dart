import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist_app/features/transactions/presentation/pages/transactions_page.dart';
import 'package:wishlist_app/features/wishlist/presentation/pages/whislist_page.dart';

void main() {
  runApp(const ProviderScope(child: Myapp()));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanças Gamificadas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: TelaPrincipalComAbas(),
    );
  }
}

class TelaPrincipalComAbas extends StatefulWidget {
  const TelaPrincipalComAbas({super.key});

  @override
  State<TelaPrincipalComAbas> createState() => _TelaPrincipalComAbasState();
}

class _TelaPrincipalComAbasState extends State<TelaPrincipalComAbas> {
  int _abaAtual = 0;

  final List<Widget> _telas = [
    const WishlistGamifiedApp(),
    const TransactionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Wishlist'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Financeiro',
          ),
        ],
        currentIndex: _abaAtual,
        onTap: (value) {
          setState(() {
            _abaAtual = value;
          });
        },
      ),
      body: _telas[_abaAtual],
    );
  }
}
