// Daily Quick Log form (bottom sheet). One log per date (UNIQUE(date)) — the
// caller passes the existing log so editing reuses its id (no duplicate). Steps
// are written through StepsService: created if absent (source dailyQuickLog),
// shown read-only ("заключено") once they exist. 0–1 photo (role=main).
// (spec §17.)

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../app/sheets.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/field.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/widgets/mood_picker.dart';
import '../../core/widgets/yes_no.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';
import '../common/photo_field.dart';
import '../steps/steps_providers.dart' show stepsServiceProvider;
import 'daily_providers.dart';

void showDailySheet(
  BuildContext context, {
  required String date,
  DailyLog? existing,
  StepEntry? existingSteps,
}) {
  showLmSheet(
    context,
    title: context.l10n.dailyTitle,
    subtitle: date,
    child: _DailyForm(date: date, existing: existing, existingSteps: existingSteps),
  );
}

class _DailyForm extends ConsumerStatefulWidget {
  const _DailyForm({required this.date, this.existing, this.existingSteps});
  final String date;
  final DailyLog? existing;
  final StepEntry? existingSteps;
  @override
  ConsumerState<_DailyForm> createState() => _DailyFormState();
}

class _DailyFormState extends ConsumerState<_DailyForm> {
  late final TextEditingController _uncomfortableWhat;
  late final TextEditingController _alcoholWhat;
  late final TextEditingController _screenTime;
  late final TextEditingController _stepsCount;
  late final TextEditingController _note;
  late int _mood;
  late bool _proud;
  late bool _didUncomfortable;
  late bool _workout;
  late bool _drankAlcohol;
  late final String _logId;
  late final AttachmentService _svc;
  List<Attachment> _photos = const [];
  bool _committed = false;

  bool get _stepsLocked => widget.existingSteps != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _uncomfortableWhat = TextEditingController(text: e?.uncomfortableWhat ?? '');
    _alcoholWhat = TextEditingController(text: e?.alcoholWhat ?? '');
    _screenTime =
        TextEditingController(text: e?.screenTimeMin?.toString() ?? '');
    _stepsCount = TextEditingController();
    _note = TextEditingController(text: e?.note ?? '');
    _mood = e?.mood ?? 7;
    _proud = e?.proud ?? true;
    _didUncomfortable = e?.didUncomfortable ?? false;
    _workout = e?.workout ?? true;
    _drankAlcohol = e?.drankAlcohol ?? false;
    _logId = e?.id ?? const Uuid().v4();
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
    _uncomfortableWhat.dispose();
    _alcoholWhat.dispose();
    _screenTime.dispose();
    _stepsCount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadPhotos() async {
    final ps = await ref
        .read(databaseProvider)
        .attachmentsDao
        .forEntity(AttachmentEntity.dailyLog, _logId);
    if (mounted) setState(() => _photos = ps);
  }

  Future<void> _addPhoto() async {
    final a = await _svc.pickAndAdd(
        entity: AttachmentEntity.dailyLog,
        entityId: _logId,
        role: AttachmentRole.main);
    if (a != null) await _loadPhotos();
  }

  Future<void> _removePhoto(Attachment a) async {
    await _svc.removeAttachment(a);
    await _loadPhotos();
  }

  Future<void> _save() async {
    final nowUtc = DateTime.now().toUtc();
    await ref.read(dailyLogsDaoProvider).save(DailyLogsCompanion(
          id: Value(_logId),
          date: Value(widget.date),
          mood: Value(_mood),
          proud: Value(_proud),
          didUncomfortable: Value(_didUncomfortable),
          uncomfortableWhat: Value(_didUncomfortable &&
                  _uncomfortableWhat.text.trim().isNotEmpty
              ? _uncomfortableWhat.text.trim()
              : null),
          workout: Value(_workout),
          drankAlcohol: Value(_drankAlcohol),
          alcoholWhat: Value(
              _drankAlcohol && _alcoholWhat.text.trim().isNotEmpty
                  ? _alcoholWhat.text.trim()
                  : null),
          screenTimeMin: Value(int.tryParse(_screenTime.text.trim())),
          note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
          createdAt: Value(widget.existing?.createdAt ?? nowUtc),
          updatedAt: Value(nowUtc),
        ));

    // Steps: create the day's value if absent (locked once it exists).
    if (!_stepsLocked) {
      final count = int.tryParse(_stepsCount.text.trim());
      if (count != null && count >= 0) {
        await ref.read(stepsServiceProvider).setFromDaily(widget.date, count);
      }
    }

    _committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.dailySaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: context.l10n.dailyMood,
          required: true,
          child: MoodPicker(value: _mood, onChanged: (v) => setState(() => _mood = v)),
        ),
        Field(
          label: context.l10n.dailyProud,
          required: true,
          child: YesNo(value: _proud, onChanged: (v) => setState(() => _proud = v)),
        ),
        Field(
          label: context.l10n.dailyUncomfortable,
          required: true,
          child: YesNo(
              value: _didUncomfortable,
              onChanged: (v) => setState(() => _didUncomfortable = v)),
        ),
        if (_didUncomfortable)
          Field(
            label: context.l10n.dailyUncomfortableWhat,
            child: LmTextArea(
                controller: _uncomfortableWhat, hintText: context.l10n.dailyOptional),
          ),
        Field(
          label: context.l10n.dailyWorkout,
          required: true,
          child: YesNo(
              value: _workout, onChanged: (v) => setState(() => _workout = v)),
        ),
        Field(
          label: context.l10n.dailyAlcohol,
          required: true,
          child: YesNo(
              value: _drankAlcohol,
              onChanged: (v) => setState(() => _drankAlcohol = v)),
        ),
        if (_drankAlcohol)
          Field(
            label: context.l10n.dailyAlcoholWhat,
            child: LmInput(controller: _alcoholWhat, hintText: context.l10n.dailyAlcoholHint),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: context.l10n.dailyScreenTime,
                hint: context.l10n.dailyMinutesUnit,
                child: LmInput(
                  controller: _screenTime,
                  hintText: '270',
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _stepsField(context)),
          ],
        ),
        Field(
          label: context.l10n.dailyNotes,
          child: LmTextArea(controller: _note, hintText: context.l10n.dailyNotesHint),
        ),
        Field(
          label: context.l10n.dailyPhoto,
          child: SinglePhotoField(
            photos: _photos,
            svc: _svc,
            onAdd: _addPhoto,
            onRemove: _removePhoto,
          ),
        ),
        const SizedBox(height: 4),
        LmButton(context.l10n.dailySaveReport,
            full: true, icon: LmIcons.check, onTap: _save),
      ],
    );
  }

  Widget _stepsField(BuildContext context) {
    if (_stepsLocked) {
      return Field(
        label: context.l10n.dailySteps,
        hint: context.l10n.dailyLocked,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadii.input),
            border: Border.all(color: AppColors.border),
          ),
          child: Text('${widget.existingSteps!.count}',
              style: AppText.body.copyWith(fontSize: 15, color: AppColors.textDim)),
        ),
      );
    }
    return Field(
      label: context.l10n.dailySteps,
      child: LmInput(
        controller: _stepsCount,
        hintText: '9420',
        keyboardType: TextInputType.number,
      ),
    );
  }
}
