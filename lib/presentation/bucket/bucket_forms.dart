// Bucket forms: item create/edit (title/why/priority/status + 0–many photos)
// and the "complete" experience sheet (feeling/date/worthIt/reflection + photos)
// which marks the item Completed. Deleting an item cleans its own and its
// experience's files + rows (spec §5.1 / §20).

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/sheets.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/widgets/mood_picker.dart';
import '../../core/widgets/segmented.dart';
import '../../core/widgets/yes_no.dart';
import '../../core/format/dates.dart';
import '../../data/daos.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';
import '../common/photo_field.dart';
import '../common/photo_form_mixin.dart';
import 'bucket_providers.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime _parseYmd(String s) => DateTime.parse(s);

/// Delete a bucket item with full cleanup: remove the item's and its
/// experience's photo files + attachment rows, then delete the item (the
/// experience row cascades).
Future<void> deleteBucketItem(
    BucketDao dao, AttachmentService svc, String itemId) async {
  final exp = await dao.experienceForItem(itemId);
  await svc.deleteForBucketItem(itemId, experienceId: exp?.id);
  await dao.deleteItem(itemId);
}

void showBucketItemSheet(BuildContext context, {BucketItem? existing}) {
  showLmSheet(
    context,
    title: existing == null ? 'Ново желание' : 'Редакция на желание',
    subtitle: 'заглавие, приоритет и статус',
    child: _BucketItemForm(existing: existing),
  );
}

void showBucketCompleteSheet(
  BuildContext context, {
  required BucketItem item,
  BucketExperience? existing,
}) {
  showLmSheet(
    context,
    title: 'Завърши желанието',
    subtitle: 'запиши преживяването си',
    child: _BucketExperienceForm(item: item, existing: existing),
  );
}

// ── Item form ───────────────────────────────────────────────────────
class _BucketItemForm extends ConsumerStatefulWidget {
  const _BucketItemForm({this.existing});
  final BucketItem? existing;
  @override
  ConsumerState<_BucketItemForm> createState() => _BucketItemFormState();
}

class _BucketItemFormState extends ConsumerState<_BucketItemForm>
    with PhotoFormMixin<_BucketItemForm> {
  late final TextEditingController _title;
  late final TextEditingController _why;
  late BucketPriority _priority;
  late BucketStatus _status;
  String? _error;

  @override
  AttachmentEntity get photoEntity => AttachmentEntity.bucketItem;
  @override
  bool get isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _why = TextEditingController(text: e?.whyWantIt ?? '');
    _priority = e?.priority ?? BucketPriority.medium;
    _status = e?.status ?? BucketStatus.idea;
    initPhotos(e?.id ?? const Uuid().v4());
  }

  @override
  void dispose() {
    cleanupOrphansIfAbandoned();
    _title.dispose();
    _why.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Заглавието е задължително');
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(bucketDaoProvider).saveItem(BucketItemsCompanion(
          id: Value(entityId),
          title: Value(_title.text.trim()),
          whyWantIt: Value(_why.text.trim().isEmpty ? null : _why.text.trim()),
          priority: Value(_priority),
          status: Value(_status),
          createdAt: Value(widget.existing?.createdAt ?? nowUtc),
          updatedAt: Value(nowUtc),
        ));
    committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Записано успешно');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: 'Заглавие',
          required: true,
          child: LmInput(
              controller: _title, hintText: 'напр. Северно сияние в Исландия'),
        ),
        Field(
          label: 'Защо го искам',
          child: LmTextArea(controller: _why, hintText: 'мотивацията зад желанието'),
        ),
        Field(
          label: 'Приоритет',
          required: true,
          child: Segmented(
            columns: 3,
            options: BucketPriority.values.map((p) => p.label).toList(),
            value: _priority.label,
            onChanged: (l) => setState(() =>
                _priority = BucketPriority.values.firstWhere((p) => p.label == l)),
          ),
        ),
        Field(
          label: 'Статус',
          required: true,
          child: Segmented(
            options: BucketStatus.values.map((s) => s.label).toList(),
            value: _status.label,
            onChanged: (l) => setState(() =>
                _status = BucketStatus.values.firstWhere((s) => s.label == l)),
          ),
        ),
        Field(
          label: 'Снимки',
          child: MultiPhotoField(
            photos: photos,
            svc: svc,
            onAdd: addPhotos,
            onRemove: removePhoto,
          ),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton('Запази', full: true, icon: LmIcons.check, onTap: _save),
      ],
    );
  }
}

// ── Experience (complete) form ──────────────────────────────────────
class _BucketExperienceForm extends ConsumerStatefulWidget {
  const _BucketExperienceForm({required this.item, this.existing});
  final BucketItem item;
  final BucketExperience? existing;
  @override
  ConsumerState<_BucketExperienceForm> createState() =>
      _BucketExperienceFormState();
}

class _BucketExperienceFormState extends ConsumerState<_BucketExperienceForm>
    with PhotoFormMixin<_BucketExperienceForm> {
  late final TextEditingController _reflection;
  late int _feeling;
  late bool _worthIt;
  late DateTime _date;

  @override
  AttachmentEntity get photoEntity => AttachmentEntity.bucketExperience;
  @override
  bool get isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _reflection = TextEditingController(text: e?.reflection ?? '');
    _feeling = e?.feelingRating ?? 8;
    _worthIt = e?.worthIt ?? true;
    _date = e != null ? _parseYmd(e.completedDate) : DateTime.now();
    initPhotos(e?.id ?? const Uuid().v4());
  }

  @override
  void dispose() {
    cleanupOrphansIfAbandoned();
    _reflection.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final dao = ref.read(bucketDaoProvider);
    final nowUtc = DateTime.now().toUtc();
    await dao.saveExperience(BucketExperiencesCompanion(
      id: Value(entityId),
      bucketItemId: Value(widget.item.id),
      completedDate: Value(_ymd(_date)),
      feelingRating: Value(_feeling),
      worthIt: Value(_worthIt),
      reflection:
          Value(_reflection.text.trim().isEmpty ? null : _reflection.text.trim()),
      createdAt: Value(widget.existing?.createdAt ?? nowUtc),
      updatedAt: Value(nowUtc),
    ));
    // Completing (or editing a completed) item keeps it in the Completed status.
    await dao.saveItem(widget.item
        .toCompanion(true)
        .copyWith(status: const Value(BucketStatus.completed), updatedAt: Value(nowUtc)));
    committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Записано успешно');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: 'Как се чувстваш?',
          required: true,
          child: MoodPicker(
              value: _feeling, onChanged: (v) => setState(() => _feeling = v)),
        ),
        Field(
          label: 'Дата на изпълнение',
          required: true,
          child: _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        ),
        Field(
          label: 'Струваше ли си?',
          required: true,
          child: YesNo(
              value: _worthIt, onChanged: (v) => setState(() => _worthIt = v)),
        ),
        Field(
          label: 'Снимки',
          child: MultiPhotoField(
            photos: photos,
            svc: svc,
            onAdd: addPhotos,
            onRemove: removePhoto,
          ),
        ),
        Field(
          label: 'Бележка / рефлексия',
          child: LmTextArea(
              controller: _reflection,
              hintText: 'Как се почувства? Би ли го направил пак?'),
        ),
        const SizedBox(height: 4),
        LmButton('Маркирай като завършено',
            full: true, icon: LmIcons.check, onTap: _save),
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
    return GestureDetector(
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
