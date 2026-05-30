import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../wishlist/presentation/controllers/user_profile_notifier.dart';
import '../controllers/transactions_notifier.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  void _abrirFormularioTransacao(BuildContext context, WidgetRef ref) async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _FormularioTransacaoDialog(),
    );

    if (resultado != null) {
      ref
          .read(transactionsProvider.notifier)
          .adicionarTransacao(
            descricao: resultado['descricao'] as String,
            valor: resultado["valor"] as double,
            tipo: resultado['tipo'] as String,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(userProfileProvider);
    final listaTransacoes = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('💰 Fluxo de Caixa Gamificado1')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Nivel ${perfil.currentLevel}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('XP: ${perfil.currentXp}'),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Minhas Moedas',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '🪙 ${perfil.virtualCoins}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => _abrirFormularioTransacao(context, ref),
              label: const Text('Registrar Nova Transação'),
              icon: Icon(Icons.add_card),
            ),

            const SizedBox(height: 24),

            Text(
              "Histórico Financeiro",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: listaTransacoes.isEmpty
                  ? const Center(
                      child: Text("Nenhuma tansação registrada ainda."),
                    )
                  : ListView.builder(
                      itemCount: listaTransacoes.length,
                      itemBuilder: (context, index) {
                        final t = listaTransacoes[index];
                        final isIncome = t.type == 'income';

                        return Card(
                          child: ListTile(
                            leading: Icon(
                              isIncome
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                            title: Text(t.description),
                            subtitle: Text(
                              "${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}",
                            ),
                            trailing: Text(
                              "${isIncome ? '+' : '-'}R\$ ${t.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ), //
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormularioTransacaoDialog extends StatefulWidget {
  const _FormularioTransacaoDialog();

  @override
  State<StatefulWidget> createState() {
    return _FormularioTransacaoDialogState();
  }
}

class _FormularioTransacaoDialogState
    extends State<_FormularioTransacaoDialog> {
  final _descController = TextEditingController();
  final _valorController = TextEditingController();
  String _tipoSelecionado = 'income';

  @override
  void dispose() {
    _descController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova movimentação 💸'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Descrição (Ex: Salário, Almoço)',
            ),
          ),
          TextField(
            controller: _valorController,
            decoration: const InputDecoration(labelText: 'Valor em R\$'),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: _tipoSelecionado,
            items: const [
              DropdownMenuItem(
                value: 'income',
                child: Text('Receita (Ganha Moedas 🪙)'),
              ),
              DropdownMenuItem(
                value: 'expense',
                child: Text('Despesa (Gasta Dinheiro)'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _tipoSelecionado = value;
                });
              }
            },
            decoration: const InputDecoration(labelText: 'Tipo de Transação'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final desc = _descController.text;
            final valor = double.tryParse(_valorController.text) ?? 0.0;

            if (desc.isNotEmpty && valor > 0) {
              Navigator.pop(context, {
                'descricao': desc,
                'valor': valor,
                'tipo': _tipoSelecionado,
              });
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
