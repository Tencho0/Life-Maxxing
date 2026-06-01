// Meal create+edit form (bottom sheet). Writes through MealsDao; a single
// optional photo (role=photo) is added/removed via AttachmentService. The meal
// id is stable for the form's lifetime so a photo can be attached before the
// row is saved; if a NEW meal is abandoned without saving, its orphan photo is
// cleaned up on dispose (spec §6, technical-spec §5.1).

import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../app/sheets.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/widgets/photo.dart';
import '../../core/widgets/segmented.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';
import 'food_providers.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime _parseYmd(String s) => DateTime.parse(s);

int? _parseInt(String t) {
  final s = t.trim();
  return s.isEmpty ? null : int.tryParse(s);
}

double? _parseDouble(String t) {
  final s = t.trim().replaceAll(',', '.');
  return s.isEmpty ? null : double.tryParse(s);
}

void showFoodSheet(BuildContext context, {Meal? existing}) {
  showLmSheet(
    context,
    title: existing == null ? 'Ново хранене' : 'Редакция на хранене',
    subtitle: 'дата и име са задължителни',
    child: _FoodForm(existing: existing),
  );
}

class _FoodForm extends ConsumerStatefulWidget {
  const _FoodForm({this.existing});
  final Meal? existing;
  @override
  ConsumerState<_FoodForm> createState() => _FoodFormState();
}

class _FoodFormState extends ConsumerState<_FoodForm> {
  late final TextEditingController _name;
  late final TextEditingController _time;
  late final TextEditingController _cals;
  late final TextEditingController _protein;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;
  late final TextEditingController _quantity;
  late final TextEditingController _note;
  late MealType _type;
  late DateTime _date;
  late final String _mealId;
  late final AttachmentService _svc;
  List<Attachment> _photos = const [];
  bool _committed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _time = TextEditingController(text: e?.time ?? '');
    _cals = TextEditingController(text: e?.calories?.toString() ?? '');
    _protein = TextEditingController(text: e?.protein?.toString() ?? '');
    _carbs = TextEditingController(text: e?.carbs?.toString() ?? '');
    _fat = TextEditingController(text: e?.fat?.toString() ?? '');
    _quantity = TextEditingController(text: e?.quantity ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _type = e?.type ?? MealType.lunch;
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
    _mealId = e?.id ?? const Uuid().v4();
    _svc = ref.read(attachmentServiceProvider);
    if (e != null) _loadPhotos();
  }

  @override
  void dispose() {
    // Abandoned new meal with an attached photo → remove the orphan files/rows.
    if (!_committed && widget.existing == null && _photos.isNotEmpty) {
      final svc = _svc;
      final orphans = List<Attachment>.of(_photos);
      Future<void>(() async {
        for (final a in orphans) {
          try {
            await svc.removeAttachment(a);
          } catch (_) {}
        }
      });
    }
    _name.dispose();
    _time.dispose();
    _cals.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    _quantity.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadPhotos() async {
    final ps = await ref
        .read(databaseProvider)
        .attachmentsDao
        .forEntity(AttachmentEntity.meal, _mealId);
    if (mounted) setState(() => _photos = ps);
  }

  Future<void> _addPhoto() async {
    final a = await _svc.pickAndAdd(
      entity: AttachmentEntity.meal,
      entityId: _mealId,
      role: AttachmentRole.photo,
    );
    if (a != null) await _loadPhotos();
  }

  Future<void> _removePhoto(Attachment a) async {
    await _svc.removeAttachment(a);
    await _loadPhotos();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Името е задължително');
      return;
    }
    final dao = ref.read(mealsDaoProvider);
    final nowUtc = DateTime.now().toUtc();
    await dao.save(MealsCompanion(
      id: Value(_mealId),
      date: Value(_ymd(_date)),
      time: Value(_time.text.trim().isEmpty ? null : _time.text.trim()),
      name: Value(_name.text.trim()),
      type: Value(_type),
      quantity:
          Value(_quantity.text.trim().isEmpty ? null : _quantity.text.trim()),
      calories: Value(_parseInt(_cals.text)),
      protein: Value(_parseDouble(_protein.text)),
      carbs: Value(_parseDouble(_carbs.text)),
      fat: Value(_parseDouble(_fat.text)),
      note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
      createdAt: Value(widget.existing?.createdAt ?? nowUtc),
      updatedAt: Value(nowUtc),
    ));
    _committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await _svc.deleteAllForEntity(AttachmentEntity.meal, _mealId);
    await ref.read(mealsDaoProvider).deleteById(_mealId);
    _committed = true;
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
          label: 'Тип хранене',
          required: true,
          child: Segmented(
            options: MealType.values.map((t) => t.label).toList(),
            value: _type.label,
            onChanged: (l) => setState(
                () => _type = MealType.values.firstWhere((t) => t.label == l)),
          ),
        ),
        Field(
          label: 'Име / описание',
          required: true,
          child: LmInput(controller: _name, hintText: 'напр. Пилешко с ориз'),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: 'Час',
                child: LmInput(controller: _time, hintText: '13:25'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: 'Калории',
                hint: 'kcal',
                child: LmInput(
                  controller: _cals,
                  hintText: '680',
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: 'Протеин',
                child: LmInput(
                  controller: _protein,
                  hintText: 'г',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: 'Въглехид.',
                child: LmInput(
                  controller: _carbs,
                  hintText: 'г',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: 'Мазнини',
                child: LmInput(
                  controller: _fat,
                  hintText: 'г',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ),
          ],
        ),
        Field(
          label: 'Количество',
          child: LmInput(controller: _quantity, hintText: 'напр. 1 купа'),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: 'Бележка',
          child: LmTextArea(controller: _note, hintText: 'незадължително'),
        ),
        Field(
          label: 'Снимка',
          child: _PhotoSection(
            photos: _photos,
            svc: _svc,
            onAdd: _addPhoto,
            onRemove: _removePhoto,
          ),
        ),
        if (_error != null) _ErrorText(_error!),
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

// ── Photo (0–1) ─────────────────────────────────────────────────────
class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.photos,
    required this.svc,
    required this.onAdd,
    required this.onRemove,
  });
  final List<Attachment> photos;
  final AttachmentService svc;
  final VoidCallback onAdd;
  final void Function(Attachment) onRemove;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return PhotoAdd(onTap: onAdd);
    final a = photos.first;
    return Row(
      children: [
        _Thumb(svc: svc, attachment: a),
        const SizedBox(width: 12),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onRemove(a),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.redSoft,
              borderRadius: BorderRadius.circular(AppRadii.input),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LmIcon(LmIcons.trash, size: 16, color: AppColors.red),
                SizedBox(width: 8),
                Text('Премахни',
                    style: TextStyle(
                        fontFamily: AppText.sans,
                        fontSize: 13,
                        color: AppColors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Renders an attachment thumbnail; tapping opens the full image.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.svc, required this.attachment});
  final AttachmentService svc;
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: svc.absolutePath(attachment.thumbPath),
      builder: (context, snap) {
        final box = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 72,
            height: 72,
            child: snap.hasData
                ? Image.file(File(snap.data!), fit: BoxFit.cover)
                : const ColoredBox(color: AppColors.card),
          ),
        );
        return GestureDetector(
          onTap: () => _openFull(context),
          child: box,
        );
      },
    );
  }

  Future<void> _openFull(BuildContext context) async {
    final full = await svc.absolutePath(attachment.filePath);
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withValues(alpha: 0.92),
          alignment: Alignment.center,
          child: InteractiveViewer(child: Image.file(File(full))),
        ),
      ),
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
      required: true,
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
          child: Text(_ymd(date), style: AppText.body.copyWith(fontSize: 15)),
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
