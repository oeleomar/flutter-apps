import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist_app/features/wishlist/presentation/controllers/user_profile_notifier.dart';
import 'package:wishlist_app/features/wishlist/presentation/controllers/wishlist_notifier.dart';

class WishlistGamifiedApp extends ConsumerWidget {
  const WishlistGamifiedApp({super.key});

  void _abrirFormularioCadastro(BuildContext context, WidgetRef ref) async {
    // 1. Abrimos o diálogo que agora é um Widget isolado e auto-contido
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _FormularioDesejoDialog(),
    );

    // 2. Quando o diálogo fecha COMPLETAMENTE, o fluxo volta para aqui,
    // na página principal, totalmente livre de conflitos de renderização!
    if (resultado != null) {
      ref
          .read(wishlistProvider.notifier)
          .adicionarDesejo(
            resultado['nome'] as String,
            resultado['preco'] as double,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(userProfileProvider);
    final listaItens = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('🎯 Minha Wishlist Gamificada')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Nível ${perfil.currentLevel}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Modeas Virtuais: 🪙 ${perfil.virtualCoins}'),
                    const SizedBox(height: 8),
                    Text('XP Atual: ${perfil.currentXp} / 100'),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => _abrirFormularioCadastro(context, ref),
              label: const Text('Adicionar novo desejo'),
              icon: Icon(Icons.add),
            ),
            const Text(
              'Meus Desejos de Consumo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: listaItens.length,
                itemBuilder: (context, index) {
                  final item = listaItens[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        'Preço estumado R\$ ${item.price.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(userProfileProvider.notifier)
                                  .economizaDinheiro();
                            },
                            child: const Text('Economizar R\$ 10'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade100,
                            ),
                            onPressed: () {
                              // Se o usuário tiver moedas suficientes no perfil
                              if (perfil.virtualCoins >= item.price) {
                                // 1. Remove o item da lista usando o Mago da lista
                                ref
                                    .read(wishlistProvider.notifier)
                                    .removerItem(item.id);

                                // 2. Executa a compra lógica no perfil (reduzir moedas e dar XP)
                                // Como você já tem a matemática de moedas e XP na função comprarItem,
                                // basta garantir que ela execute a redução.
                                ref
                                    .read(userProfileProvider.notifier)
                                    .comprarItem(item.price);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Moedas insuficientes! 🪙'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },

                            child: const Text('Comprar'),
                          ),
                        ],
                      ),
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

class _FormularioDesejoDialog extends StatefulWidget {
  const _FormularioDesejoDialog();

  @override
  State<_FormularioDesejoDialog> createState() =>
      _FormularioDesejoDialogState();
}

class _FormularioDesejoDialogState extends State<_FormularioDesejoDialog> {
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();

  @override
  void dispose() {
    // Garante a limpeza correta dos componentes ao fechar
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Item de Desejo 🎯'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome do Desejo'),
          ),
          TextField(
            controller: _precoController,
            decoration: const InputDecoration(labelText: 'Preço (R\$)'),
            keyboardType: TextInputType.number,
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
            final nome = _nomeController.text;
            final preco = double.tryParse(_precoController.text) ?? 0.0;

            if (nome.isNotEmpty && preco > 0) {
              // Devolve os dados para quem chamou e fecha. Zero contacto com Riverpod aqui dentro!
              Navigator.pop(context, {'nome': nome, 'preco': preco});
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
