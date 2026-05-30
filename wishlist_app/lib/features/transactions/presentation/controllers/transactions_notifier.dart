import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../wishlist/presentation/controllers/user_profile_notifier.dart';
import '../../data/models/transaction_model.dart';

class TransactionsNotifier extends Notifier<List<TransactionModel>> {
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  List<TransactionModel> build() {
    _carregarTransacoes();

    return [];
  }

  Future<void> _carregarTransacoes() async {
    try {
      final dados = await _db.select(_db.transactions).get();

      final listaConvertida = dados.map((e) {
        return TransactionModel(
          id: e.id,
          description: e.description,
          amount: e.amount,
          type: e.type,
          createdAt: e.createdAt,
        );
      }).toList();

      listaConvertida.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = listaConvertida;
    } catch (e) {
      state = [];
    }
  }

  Future<void> adicionarTransacao({
    required String descricao,
    required double valor,
    required String tipo,
  }) async {
    final novaTrasacao = TransactionModel(
      id: DateTime.now().toString(),
      description: descricao,
      amount: valor,
      type: tipo,
      createdAt: DateTime.now(),
    );

    state = [novaTrasacao, ...state];

    await _db
        .into(_db.transactions)
        .insert(
          TransactionsCompanion.insert(
            id: novaTrasacao.id,
            description: novaTrasacao.description,
            amount: novaTrasacao.amount,
            type: novaTrasacao.type,
            createdAt: novaTrasacao.createdAt,
          ),
        );
    if (tipo == "income") {
      int moedasGanhas = valor.toInt();
      int xpGanho = 15;

      ref
          .read(userProfileProvider.notifier)
          .receberRecompensaTransacao(moedas: moedasGanhas, xp: xpGanho);
    }
  }
}

// Provedor global da lista de transações financeira
final transactionsProvider =
    NotifierProvider<TransactionsNotifier, List<TransactionModel>>(() {
      return TransactionsNotifier();
    });
