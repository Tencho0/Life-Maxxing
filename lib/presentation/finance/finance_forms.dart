// Expense / Income create+edit forms and the expense-or-income chooser.
// Shown as bottom sheets; write through FinanceDao; validate before saving.

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/sheets.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/widgets/segmented.dart';
import '../../core/format/dates.dart';
import '../../domain/period.dart' show ymd;
import '../../data/database.dart';
import '../../domain/enums.dart';
import 'finance_providers.dart';

int? _parseCents(String text) {
  final cleaned = text.trim().replaceAll(' ', '').replaceAll(',', '.');
  final v = double.tryParse(cleaned);
  if (v == null) return null;
  return (v * 100).round();
}

DateTime _parseYmd(String s) => DateTime.parse(s);

void showExpenseSheet(BuildContext context, {Expense? existing}) {
  showLmSheet(
    context,
    title: existing == null ? 'Нов разход' : 'Редакция на разход',
    subtitle: 'сума, категория, описание',
    child: _ExpenseForm(existing: existing),
  );
}

void showIncomeSheet(BuildContext context, {IncomeEntry? existing}) {
  showLmSheet(
    context,
    title: existing == null ? 'Нов приход' : 'Редакция на приход',
    subtitle: 'сума и източник са задължителни',
    child: _IncomeForm(existing: existing),
  );
}

/// Expense-or-income chooser (the Finance `+`).
void showFinanceChooser(BuildContext context) {
  showLmSheet(
    context,
    title: 'Нов запис',
    subtitle: 'разход или приход?',
    child: Row(
      children: [
        Expanded(
          child: _ChooserCard(
            label: 'Разход', sub: 'пари навън', icon: LmIcons.expense,
            color: AppColors.red,
            onTap: () {
              Navigator.pop(context);
              showExpenseSheet(context);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ChooserCard(
            label: 'Приход', sub: 'пари навътре', icon: LmIcons.income,
            color: AppColors.green,
            onTap: () {
              Navigator.pop(context);
              showIncomeSheet(context);
            },
          ),
        ),
      ],
    ),
  );
}

class _ChooserCard extends StatelessWidget {
  const _ChooserCard({
    required this.label,
    required this.sub,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label, sub;
  final LmIcons icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: AppColors.white05,
                  borderRadius: BorderRadius.circular(14)),
              child: LmIcon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 16),
            Text(label, style: AppText.sheetTitle),
            const SizedBox(height: 2),
            Text(sub, style: AppText.monoFaint),
          ],
        ),
      ),
    );
  }
}

// ── Expense form ────────────────────────────────────────────────────
class _ExpenseForm extends ConsumerStatefulWidget {
  const _ExpenseForm({this.existing});
  final Expense? existing;
  @override
  ConsumerState<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<_ExpenseForm> {
  late final TextEditingController _amount;
  late final TextEditingController _desc;
  late final TextEditingController _note;
  late ExpenseCategory _category;
  late PaymentMethod _payment;
  late DateTime _date;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _amount = TextEditingController(
        text: e != null ? (e.amountCents / 100).toStringAsFixed(2) : '');
    _desc = TextEditingController(text: e?.description ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _category = e?.category ?? ExpenseCategory.food;
    _payment = e?.paymentMethod ?? PaymentMethod.card;
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _desc.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final cents = _parseCents(_amount.text);
    if (cents == null || cents <= 0) {
      setState(() => _error = 'Въведи валидна сума (> 0)');
      return;
    }
    if (_desc.text.trim().isEmpty) {
      setState(() => _error = 'Описанието е задължително');
      return;
    }
    final dao = ref.read(financeDaoProvider);
    final nowUtc = DateTime.now().toUtc();
    await dao.saveExpense(ExpensesCompanion(
      id: Value(widget.existing?.id ?? const Uuid().v4()),
      date: Value(ymd(_date)),
      amountCents: Value(cents),
      category: Value(_category),
      description: Value(_desc.text.trim()),
      paymentMethod: Value(_payment),
      note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
      createdAt: Value(widget.existing?.createdAt ?? nowUtc),
      updatedAt: Value(nowUtc),
    ));
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await ref.read(financeDaoProvider).deleteExpense(widget.existing!.id);
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Изтрито');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: 'Сума',
          required: true,
          hint: '€',
          child: LmInput(
            controller: _amount,
            hintText: '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppText.statLg.copyWith(fontSize: 22),
          ),
        ),
        Field(
          label: 'Категория',
          required: true,
          child: Segmented(
            options: ExpenseCategory.values.map((c) => localizedLabel(context, c)).toList(),
            value: localizedLabel(context, _category),
            onChanged: (l) => setState(() => _category =
                ExpenseCategory.values.firstWhere((c) => localizedLabel(context, c) == l)),
          ),
        ),
        Field(
          label: 'Описание',
          required: true,
          child: LmInput(controller: _desc, hintText: 'напр. Зареждане OMV'),
        ),
        Field(
          label: 'Начин на плащане',
          child: Segmented(
            options: const ['Карта', 'В брой', 'Друго'],
            value: localizedLabel(context, _payment),
            onChanged: (l) => setState(() => _payment =
                PaymentMethod.values.firstWhere((p) => localizedLabel(context, p) == l)),
          ),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: 'Бележка',
          child: LmTextArea(controller: _note, hintText: 'незадължително'),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton('Запази', full: true, icon: LmIcons.check, onTap: _save),
        if (widget.existing != null) ...[
          const SizedBox(height: 10),
          LmButton('Изтрий', full: true, variant: LmButtonVariant.danger,
              icon: LmIcons.trash, onTap: _delete),
        ],
      ],
    );
  }
}

// ── Income form ─────────────────────────────────────────────────────
class _IncomeForm extends ConsumerStatefulWidget {
  const _IncomeForm({this.existing});
  final IncomeEntry? existing;
  @override
  ConsumerState<_IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends ConsumerState<_IncomeForm> {
  late final TextEditingController _amount;
  late final TextEditingController _source;
  late final TextEditingController _note;
  late IncomeCategory _category;
  late DateTime _date;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _amount = TextEditingController(
        text: e != null ? (e.amountCents / 100).toStringAsFixed(2) : '');
    _source = TextEditingController(text: e?.source ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _category = e?.category ?? IncomeCategory.salary;
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _source.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final cents = _parseCents(_amount.text);
    if (cents == null || cents <= 0) {
      setState(() => _error = 'Въведи валидна сума (> 0)');
      return;
    }
    if (_source.text.trim().isEmpty) {
      setState(() => _error = 'Източникът е задължителен');
      return;
    }
    final dao = ref.read(financeDaoProvider);
    final nowUtc = DateTime.now().toUtc();
    await dao.saveIncome(IncomeCompanion(
      id: Value(widget.existing?.id ?? const Uuid().v4()),
      date: Value(ymd(_date)),
      amountCents: Value(cents),
      source: Value(_source.text.trim()),
      category: Value(_category),
      note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
      createdAt: Value(widget.existing?.createdAt ?? nowUtc),
      updatedAt: Value(nowUtc),
    ));
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await ref.read(financeDaoProvider).deleteIncome(widget.existing!.id);
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Изтрито');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: 'Сума',
          required: true,
          hint: '€',
          child: LmInput(
            controller: _amount,
            hintText: '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppText.statLg.copyWith(fontSize: 22),
          ),
        ),
        Field(
          label: 'Източник',
          required: true,
          child: LmInput(controller: _source, hintText: 'напр. Заплата — Klevret'),
        ),
        Field(
          label: 'Категория',
          required: true,
          child: Segmented(
            options: IncomeCategory.values.map((c) => localizedLabel(context, c)).toList(),
            value: localizedLabel(context, _category),
            onChanged: (l) => setState(() => _category =
                IncomeCategory.values.firstWhere((c) => localizedLabel(context, c) == l)),
          ),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: 'Бележка',
          child: LmTextArea(controller: _note, hintText: 'незадължително'),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton('Запази', full: true, icon: LmIcons.check, onTap: _save),
        if (widget.existing != null) ...[
          const SizedBox(height: 10),
          LmButton('Изтрий', full: true, variant: LmButtonVariant.danger,
              icon: LmIcons.trash, onTap: _delete),
        ],
      ],
    );
  }
}

// ── Shared sub-widgets ──────────────────────────────────────────────
class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onPick});
  final DateTime date;
  final ValueChanged<DateTime> onPick;
  @override
  Widget build(BuildContext context) {
    return Field(
      label: 'Дата',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) onPick(picked);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadii.input),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(dmyDate(date), style: AppText.body.copyWith(fontSize: 15)),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(text,
            style: AppText.monoFaint.copyWith(color: AppColors.red, fontSize: 12)),
      );
}
