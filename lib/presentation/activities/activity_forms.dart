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
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n_ext.dart';
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
    title: existing == null
        ? context.l10n.activityNewTitle
        : context.l10n.activityEditTitle,
    subtitle: context.l10n.activitySheetSubtitle,
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
        setState(() => _error = context.l10n.activityDurationPositive);
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
      showLmToast(context, context.l10n.activitySaved);
    }
  }

  Future<void> _delete() async {
    await _svc.deleteAllForEntity(AttachmentEntity.activity, _id);
    await ref.read(activitiesDaoProvider).deleteById(_id);
    _committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.activityDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: context.l10n.activityFieldType,
          required: true,
          child: Segmented(
            options:
                ActivityType.values.map((t) => localizedLabel(context, t)).toList(),
            value: localizedLabel(context, _type),
            onChanged: (l) => setState(() => _type = ActivityType.values
                .firstWhere((t) => localizedLabel(context, t) == l)),
          ),
        ),
        Field(
          label: context.l10n.activityFieldName,
          child: LmInput(controller: _name, hintText: context.l10n.activityNameHint),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: context.l10n.activityFieldStart,
                child: LmInput(controller: _start, hintText: '18:30'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: context.l10n.activityFieldEnd,
                child: LmInput(controller: _end, hintText: '19:35'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: context.l10n.activityFieldMinutes,
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
          label: context.l10n.activityFieldIntensity,
          child: Segmented(
            columns: 3,
            options:
                Intensity.values.map((i) => localizedLabel(context, i)).toList(),
            value: _intensity == null ? '' : localizedLabel(context, _intensity!),
            onChanged: (l) => setState(() => _intensity = Intensity.values
                .firstWhere((i) => localizedLabel(context, i) == l)),
          ),
        ),
        Field(
          label: context.l10n.activityFieldQuality,
          child: Scale10(
            value: _quality,
            color: AppColors.accent,
            onChanged: (v) => setState(() => _quality = v),
          ),
        ),
        Field(
          label: context.l10n.activityFieldMoodAfter,
          child: Scale10(
            value: _moodAfter,
            color: AppColors.green,
            onChanged: (v) => setState(() => _moodAfter = v),
          ),
        ),
        Field(
          label: context.l10n.activityFieldNote,
          child: LmTextArea(controller: _note, hintText: context.l10n.activityNoteHint),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: context.l10n.activityFieldPhoto,
          child: SinglePhotoField(
            photos: _photos,
            svc: _svc,
            onAdd: _addPhoto,
            onRemove: _removePhoto,
          ),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton(context.l10n.actionSave, full: true, icon: LmIcons.check, onTap: _save),
        if (widget.existing != null) ...[
          const SizedBox(height: 10),
          LmButton(context.l10n.actionDelete,
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
      label: context.l10n.activityFieldDate,
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
