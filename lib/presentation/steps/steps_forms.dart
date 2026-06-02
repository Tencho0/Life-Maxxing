// Steps create+edit form (bottom sheet). Writes through StepsService so the
// one-value-per-date rule and source provenance are preserved (spec §18 / §3.5).
// Editing happens only here; the Daily Quick Log shows steps read-only.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/sheets.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/format/dates.dart';
import '../../data/database.dart';
import 'steps_providers.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime _parseYmd(String s) => DateTime.parse(s);

void showStepsSheet(BuildContext context, {StepEntry? existing}) {
  showLmSheet(
    context,
    title: 'Крачки',
    subtitle: 'една стойност на ден',
    child: _StepsForm(existing: existing),
  );
}

class _StepsForm extends ConsumerStatefulWidget {
  const _StepsForm({this.existing});
  final StepEntry? existing;
  @override
  ConsumerState<_StepsForm> createState() => _StepsFormState();
}

class _StepsFormState extends ConsumerState<_StepsForm> {
  late final TextEditingController _count;
  late final TextEditingController _note;
  late DateTime _date;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _count = TextEditingController(text: e?.count.toString() ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
  }

  @override
  void dispose() {
    _count.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final count = int.tryParse(_count.text.trim());
    if (count == null || count < 0) {
      setState(() => _error = 'Въведи валиден брой крачки');
      return;
    }
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();
    await ref
        .read(stepsServiceProvider)
        .setFromStepsModule(_ymd(_date), count, note: note);
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await ref.read(stepsServiceProvider).deleteForDate(widget.existing!.date);
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
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: 'Брой крачки',
          required: true,
          child: LmInput(
            controller: _count,
            hintText: '9420',
            keyboardType: TextInputType.number,
            style: AppText.statLg.copyWith(fontSize: 22),
          ),
        ),
        Field(
          label: 'Бележка',
          child: LmTextArea(controller: _note, hintText: 'незадължително'),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(_error!,
                style: AppText.monoFaint
                    .copyWith(color: AppColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 4),
        LmButton('Запази', full: true, icon: LmIcons.check, onTap: _save),
        if (widget.existing != null) ...[
          const SizedBox(height: 10),
          LmButton('Изтрий',
              full: true,
              variant: LmButtonVariant.danger,
              icon: LmIcons.trash,
              onTap: _delete),
        ],
      ],
    );
  }
}

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
