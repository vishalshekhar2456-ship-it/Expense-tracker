import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isIncome;

  const AddTransactionScreen({
    super.key,
    required this.isIncome,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  late String _selectedCategory;

  late List<String> _categories;

  @override
  void initState() {
    super.initState();

    _categories = widget.isIncome
        ? [
            "Salary",
            "Freelance",
            "Investment",
            "Gift",
            "Bonus",
            "Other",
          ]
        : [
            "Food",
            "Transport",
            "Shopping",
            "Bills",
            "Entertainment",
            "Health",
            "Subscription",
            "Other",
          ];

    _selectedCategory = _categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DashboardProvider>();

    final amount = double.parse(_amountController.text);

    if (widget.isIncome) {
      provider.addIncome(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        amount: amount,
      );
    } else {
      provider.addExpense(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        amount: amount,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isIncome ? "Add Income" : "Add Expense";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "Please enter a title"
                        : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                  prefixText: "\$ ",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter an amount";
                  }

                  final amount = double.tryParse(value);

                  if (amount == null || amount <= 0) {
                    return "Enter a valid amount";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  child: Text(
                    widget.isIncome ? "Add Income" : "Add Expense",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}