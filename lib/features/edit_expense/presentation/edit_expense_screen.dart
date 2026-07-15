//flutter imports
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;

//theme imports
import 'package:expenseful/app/theme.dart';

//data imports
import 'package:expenseful/data/database.dart';

// Widgets imports
import 'package:expenseful/features/add_expense/presentation/widgets/save_bar.dart';
import 'package:expenseful/features/add_expense/presentation/widgets/category_section.dart';
import 'package:expenseful/features/add_expense/presentation/widgets/expense_form.dart';
import 'package:expenseful/features/add_expense/presentation/widgets/amount_card.dart';
import 'package:expenseful/features/add_expense/presentation/expense_validation.dart';
import 'package:expenseful/core/amount_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenseful/providers/database_provider.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _merchantController;
  late final TextEditingController _notesController;
  late DateTime _selectedDate;
  late String? _selectedCategoryId;
  String? _amountError;
  String? _merchantError;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _amountController =
        TextEditingController(text: expense.amount.toStringAsFixed(2));
    _merchantController = TextEditingController(text: expense.merchant);
    _notesController = TextEditingController(text: expense.notes ?? '');
    _selectedDate = expense.date;
    _selectedCategoryId = expense.categoryId;
  }

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

    final notes = _notesController.text.trim();

    await db.updateExpense(
      widget.expense.copyWith(
        amount: amount,
        merchant: _merchantController.text.trim(),
        notes: Value(notes.isEmpty ? null : notes),
        date: _selectedDate,
        categoryId: Value(_selectedCategoryId),
        updatedAt: DateTime.now(),
      ),
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
        title: Text('Edit Expense',
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
          SaveBar(onSave: () => _saveExpense(), label: 'Update Expense'),
        ],
      ),
    );
  }
}
