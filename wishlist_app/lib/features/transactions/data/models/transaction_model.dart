class TransactionModel {
  final String id;
  final String description;
  final double amount;
  final String type; // 'income' ou 'expense'
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.createdAt,
  });
}
