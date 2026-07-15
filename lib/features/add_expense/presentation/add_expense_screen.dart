//flutter imports
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//theme imports
import 'package:expenseful/app/theme.dart';

// Widgets imports
import 'widgets/save_bar.dart';
import 'widgets/category_section.dart';
import 'widgets/expense_form.dart';
import 'widgets/amount_card.dart';
import 'expense_validation.dart';
import 'package:expenseful/core/amount_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenseful/providers/database_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends ConsumerState<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  String? _amountError;
  String? _merchantError;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    final errors = validateExpenseInput(
      amountText: _amountController.text,
      merchantText: _merchantController.text,
    );

    if (errors.amount != null || errors.merchant != null) {
      setState(() {
        _amountError = errors.amount;
        _merchantError = errors.merchant;
      });
      return;
    }

    final amount = parseAmount(_amountController.text)!;
    final db = ref.read(appDatabaseProvider);

    await db.addExpense(
      amount: amount,
      merchant: _merchantController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      date: _selectedDate,
      categoryId: _selectedCategoryId,
    );

    if (!mounted) return;

    context.pop();
  }

  String get _formattedDate {
    return '${_selectedDate.day.toString().padLeft(2, '0')}/'
        '${_selectedDate.month.toString().padLeft(2, '0')}/'
        '${_selectedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperBackground,
      appBar: AppBar(
        backgroundColor: AppColors.paperBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.plumInk),
          onPressed: () => context.pop(),
        ),
        title: Text('New Expense',
            style: AppTypography.displayMedium.copyWith(fontSize: 18)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AmountCard(
                  controller: _amountController,
                  errorText: _amountError,
                  onChanged: (_) {
                    if (_amountError != null) {
                      setState(() => _amountError = null);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                FormCard(
                  merchantController: _merchantController,
                  notesController: _notesController,
                  date: _formattedDate,
                  onDateTap: _pickDate,
                  merchantError: _merchantError,
                  onMerchantChanged: (_) {
                    if (_merchantError != null) {
                      setState(() => _merchantError = null);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                CategorySection(
                  selectedCategoryId: _selectedCategoryId,
                  onSelect: (id) => setState(() => _selectedCategoryId = id),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
          SaveBar(onSave: () => _saveExpense()),
        ],
      ),
    );
  }
}
