class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'note': note,
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'],
    title: map['title'],
    amount: map['amount'],
    category: map['category'],
    date: DateTime.parse(map['date']),
    note: map['note'],
  );
}