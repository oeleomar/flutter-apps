import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class UserProfiles extends Table {
  TextColumn get id => text()();
  IntColumn get currentXp => integer().withDefault(const Constant(0))();
  IntColumn get currentLevel => integer().withDefault(const Constant(1))();
  IntColumn get virtualCoins => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class WishItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [UserProfiles, WishItems, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 3) {
          await m.createAll();
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
