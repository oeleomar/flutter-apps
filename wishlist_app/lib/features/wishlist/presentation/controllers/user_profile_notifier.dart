import 'package:riverpod/riverpod.dart';
import 'package:wishlist_app/core/database/app_database.dart';
import 'package:wishlist_app/features/wishlist/presentation/controllers/user_profile_state.dart';
import 'package:drift/drift.dart';

class UserProfileNotifier extends Notifier<UserProfileState> {
  AppDatabase get _db => ref.read(databaseProvider);

  final String _perfilId = 'usuario_principal';

  @override
  UserProfileState build() {
    final estadoInicial = UserProfileState(
      currentLevel: 1,
      currentXp: 0,
      virtualCoins: 0,
    );

    _carregarPerfilDoBanco();

    return estadoInicial;
  }

  Future<void> _carregarPerfilDoBanco() async {
    final consulta = await (_db.select(
      _db.userProfiles,
    )..where((t) => t.id.equals(_perfilId))).getSingleOrNull();

    if (consulta != null) {
      state = state.copyWith(
        currentXp: consulta.currentXp,
        currentLevel: consulta.currentLevel,
        virtualCoins: consulta.virtualCoins,
      );
    } else {
      await _db
          .into(_db.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              id: _perfilId,
              currentXp: const Value(0),
              currentLevel: const Value(1),
              virtualCoins: const Value(0),
            ),
          );
    }
  }

  Future<void> _salvarNoBanco(int xp, int nivel, int moedas) async {
    await (_db.update(
      _db.userProfiles,
    )..where((tbl) => tbl.id.equals(_perfilId))).write(
      UserProfilesCompanion(
        currentXp: Value(xp),
        currentLevel: Value(nivel),
        virtualCoins: Value(moedas),
      ),
    );
  }

  Future<void> economizaDinheiro() async {
    int novoXp = state.currentXp + 10;
    int novoNivel = state.currentLevel;
    int novasMoedas = state.virtualCoins + 10;

    if (novoXp >= 100) {
      novoNivel += 1;
      novoXp = 0;
    }

    state = state.copyWith(
      currentXp: novoXp,
      currentLevel: novoNivel,
      virtualCoins: novasMoedas,
    );

    await _salvarNoBanco(novoXp, novoNivel, novasMoedas);
  }

  void comprarItem(double precoDoItem) async {
    int novasMoedas = state.virtualCoins - precoDoItem.toInt();
    int novoXp = state.currentXp + 50; // Bónus de 50 XP pela compra!
    int novoNivel = state.currentLevel;

    // Regra do Level UP
    if (novoXp >= 100) {
      novoNivel += 1;
      novoXp = novoXp - 100;
    }

    // 1. Atualiza a interface imediatamente (Local-First)
    state = state.copyWith(
      virtualCoins: novasMoedas,
      currentXp: novoXp,
      currentLevel: novoNivel,
    );

    // 2. Grava a alteração de forma permanente no Drift (SQLite)
    await _salvarNoBanco(novoXp, novoNivel, novasMoedas);
  }

  void receberRecompensaTransacao({
    required int moedas,
    required int xp,
  }) async {
    int novoXp = state.currentXp + xp;
    int novoNivel = state.currentLevel;
    int novasMoedas = state.virtualCoins + moedas;

    if (novoXp >= 100) {
      novoNivel += 1;
      novoXp = novoXp - 100;
    }

    state = state.copyWith(
      currentXp: novoXp,
      currentLevel: novoNivel,
      virtualCoins: novasMoedas,
    );

    await _salvarNoBanco(novoXp, novoNivel, novasMoedas);
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfileState>(() {
      return UserProfileNotifier();
    });
