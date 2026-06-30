class TransactionModel {
  final int id;
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final bool isIncome;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isIncome,
  });
}