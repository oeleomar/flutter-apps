import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist_app/core/database/app_database.dart';
import 'package:wishlist_app/features/wishlist/data/models/wish_item_model.dart';

class WishlistNotifier extends Notifier<List<WishItemModel>> {
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  List<WishItemModel> build() {
    _carregarItensDoBanco();

    return [];
  }

  Future<void> _carregarItensDoBanco() async {
    final listaDoBanco = await _db.select(_db.wishItems).get();

    print(listaDoBanco);

    final convertidos = listaDoBanco.map((e) {
      return WishItemModel(id: e.id, name: e.name, price: e.price);
    }).toList();

    state = convertidos;
  }

  Future<void> adicionarDesejo(String nome, double preco) async {
    final novoItem = WishItemModel(
      id: DateTime.now().toString(),
      name: nome,
      price: preco,
    );

    // Atualiza apenas a lista
    state = [...state, novoItem];

    await _db
        .into(_db.wishItems)
        .insert(
          WishItemsCompanion.insert(
            id: novoItem.id,
            name: novoItem.name,
            price: novoItem.price,
          ),
        );
  }

  void removerItem(String id) async {
    state = state.where((element) => element.id != id).toList();

    await (_db.delete(_db.wishItems)..where((t) => t.id.equals(id))).go();
  }
}

// O provedor da lista
final wishlistProvider =
    NotifierProvider<WishlistNotifier, List<WishItemModel>>(() {
      return WishlistNotifier();
    });
