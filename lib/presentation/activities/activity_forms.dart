// Activity create+edit form (bottom sheet). Writes through ActivitiesDao; a
// single optional photo (role=photo) is added/removed via AttachmentService
// with the same stable-id + abandon-cleanup pattern as the Food form. Required:
// date + type only; name and the rest are optional (spec §7.2/§7.4). Duration,
// when present, must be > 0.

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
import '../../core/widgets/scale10.dart';
import '../../core/widgets/segmented.dart';
import '../../core/format/dates.dart';
import '../../domain/period.dart' show ymd;
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';
import '../common/photo_field.dart';
import 'activity_providers.dart';

DateTime _parseYmd(String s) => DateTime.parse(s);

void showActivitySheet(BuildContext context, {Activity? existing}) {
  showLmSheet(
    context,
    title: existing == null ? 'Нова активност' : 'Редакция на активност',
    subtitle: 'дата и тип са задължителни',
    child: _ActivityForm(existing: existing),
  );
}

class _ActivityForm extends ConsumerStatefulWidget {
  const _ActivityForm({this.existing});
  final Activity? existing;
  @override
  ConsumerState<_ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends ConsumerState<_ActivityForm> {
  late final TextEditingController _name;
  late final TextEditingController _start;
  late final TextEditingController _end;
  late final TextEditingController _duration;
  late final TextEditingController _note;
  late ActivityType _type;
  Intensity? _intensity;
  int? _quality;
  int? _moodAfter;
  late DateTime _date;
  late final String _id;
  late final AttachmentService _svc;
  List<Attachment> _photos = const [];
  bool _committed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _start = TextEditingController(text: e?.startTime ?? '');
    _end = TextEditingController(text: e?.endTime ?? '');
    _duration = TextEditingController(text: e?.durationMin?.toString() ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _type = e?.type ?? ActivityType.gym;
    _intensity = e?.intensity;
    _quality = e?.quality;
    _moodAfter = e?.moodAfter;
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
    _id = e?.id ?? const Uuid().v4();
    _svc = ref.read(attachmentServiceProvider);
    if (e != null) _loadPhotos();
  }

  @override
  void dispose() {
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
    _start.dispose();
    _end.dispose();
    _duration.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadPhotos() async {
    final ps = await ref
        .read(databaseProvider)
        .attachmentsDao
        .forEntity(AttachmentEntity.activity, _id);
    if (mounted) setState(() => _photos = ps);
  }

  Future<void> _addPhoto() async {
    final a = await _svc.pickAndAdd(
      entity: AttachmentEntity.activity,
      entityId: _id,
      role: AttachmentRole.photo,
    );
    if (a != null) await _loadPhotos();
  }

  Future<void> _removePhoto(Attachment a) async {
    await _svc.removeAttachment(a);
    await _loadPhotos();
  }

  Future<void> _save() async {
    final durText = _duration.text.trim();
    int? dur;
    if (durText.isNotEmpty) {
      dur = int.tryParse(durText);
      if (dur == null || dur <= 0) {
        setState(() => _error = 'Времетраенето трябва да е > 0');
        return;
      }
    }
    final dao = ref.read(activitiesDaoProvider);
    final nowUtc = DateTime.now().toUtc();
    String? t(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    await dao.save(ActivitiesCompanion(
      id: Value(_id),
      date: Value(ymd(_date)),
      type: Value(_type),
      name: Value(t(_name)),
      startTime: Value(t(_start)),
      endTime: Value(t(_end)),
      durationMin: Value(dur),
      intensity: Value(_intensity),
      quality: Value(_quality),
      moodAfter: Value(_moodAfter),
      note: Value(t(_note)),
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
    await _svc.deleteAllForEntity(AttachmentEntity.activity, _id);
    await ref.read(activitiesDaoProvider).deleteById(_id);
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
          label: 'Тип активност',
          required: true,
          child: Segmented(
            options: ActivityType.values.map((t) => t.label).toList(),
            value: _type.label,
            onChanged: (l) => setState(() =>
                _type = ActivityType.values.firstWhere((t) => t.label == l)),
          ),
        ),
        Field(
          label: 'Име / описание',
          child: LmInput(controller: _name, hintText: 'напр. Гръб и бицепс'),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: 'Начало',
                child: LmInput(controller: _start, hintText: '18:30'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: 'Край',
                child: LmInput(controller: _end, hintText: '19:35'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: 'Мин.',
                child: LmInput(
                  controller: _duration,
                  hintText: '65',
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        Field(
          label: 'Интензивност',
          child: Segmented(
            columns: 3,
            options: Intensity.values.map((i) => i.label).toList(),
            value: _intensity?.label ?? '',
            onChanged: (l) => setState(() =>
                _intensity = Intensity.values.firstWhere((i) => i.label == l)),
          ),
        ),
        Field(
          label: 'Продуктивност / качество',
          child: Scale10(
            value: _quality,
            color: AppColors.accent,
            onChanged: (v) => setState(() => _quality = v),
          ),
        ),
        Field(
          label: 'Настроение след',
          child: Scale10(
            value: _moodAfter,
            color: AppColors.green,
            onChanged: (v) => setState(() => _moodAfter = v),
          ),
        ),
        Field(
          label: 'Бележка',
          child: LmTextArea(controller: _note, hintText: 'незадължително'),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: 'Снимка',
          child: SinglePhotoField(
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
