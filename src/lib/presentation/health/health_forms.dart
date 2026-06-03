// Health forms (bottom sheets): BP, Medication, Health-event, Lab test.
// BP/Med write through HealthDao; Event/Lab additionally carry 0–many photos via
// AttachmentService (PhotoFormMixin handles load/add/remove + abandon-cleanup).
// Rules: BP requires sys > dia (live); event subtype applies only to the dentist
// type; lab requires lab + reason (spec §12–§15).

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/sheets.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/icons/lm_icons.dart';
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
import '../common/photo_field.dart';
import '../common/photo_form_mixin.dart';
import 'health_providers.dart';

DateTime _parseYmd(String s) => DateTime.parse(s);

String _hm(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

int? _parseCents(String text) {
  final cleaned = text.trim().replaceAll(' ', '').replaceAll(',', '.');
  if (cleaned.isEmpty) return null;
  final v = double.tryParse(cleaned);
  return v == null ? null : (v * 100).round();
}

// ── show* entry points ──────────────────────────────────────────────
void showBpSheet(BuildContext context, {BloodPressureLog? existing}) =>
    showLmSheet(context,
        title: existing == null
            ? context.l10n.healthBpSheetTitle
            : context.l10n.healthBpSheetEditTitle,
        subtitle: context.l10n.healthBpSheetSubtitle,
        child: _BpForm(existing: existing));

void showMedSheet(BuildContext context, {MedicationLog? existing}) =>
    showLmSheet(context,
        title: existing == null
            ? context.l10n.healthMedSheetTitle
            : context.l10n.healthMedSheetEditTitle,
        subtitle: context.l10n.healthMedSheetSubtitle,
        child: _MedForm(existing: existing));

void showEventSheet(BuildContext context, {HealthEvent? existing}) =>
    showLmSheet(context,
        title: existing == null
            ? context.l10n.healthEventSheetTitle
            : context.l10n.healthEventSheetEditTitle,
        subtitle: context.l10n.healthEventSheetSubtitle,
        child: _EventForm(existing: existing));

void showLabSheet(BuildContext context, {LabTest? existing}) =>
    showLmSheet(context,
        title: existing == null
            ? context.l10n.healthLabSheetTitle
            : context.l10n.healthLabSheetEditTitle,
        subtitle: context.l10n.healthLabSheetSubtitle,
        child: _LabForm(existing: existing));

// ── Blood pressure ──────────────────────────────────────────────────
class _BpForm extends ConsumerStatefulWidget {
  const _BpForm({this.existing});
  final BloodPressureLog? existing;
  @override
  ConsumerState<_BpForm> createState() => _BpFormState();
}

class _BpFormState extends ConsumerState<_BpForm> {
  late final TextEditingController _time;
  late final TextEditingController _sys;
  late final TextEditingController _dia;
  late final TextEditingController _pulse;
  late final TextEditingController _note;
  late DateTime _date;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _time = TextEditingController(text: e?.time ?? _hm(DateTime.now()));
    _sys = TextEditingController(text: e?.systolic.toString() ?? '');
    _dia = TextEditingController(text: e?.diastolic.toString() ?? '');
    _pulse = TextEditingController(text: e?.pulse.toString() ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
  }

  @override
  void dispose() {
    _time.dispose();
    _sys.dispose();
    _dia.dispose();
    _pulse.dispose();
    _note.dispose();
    super.dispose();
  }

  void _revalidate() {
    final s = int.tryParse(_sys.text.trim());
    final d = int.tryParse(_dia.text.trim());
    setState(() => _error =
        (s != null && d != null && s <= d) ? context.l10n.healthSysGtDia : null);
  }

  Future<void> _save() async {
    final s = int.tryParse(_sys.text.trim());
    final d = int.tryParse(_dia.text.trim());
    final p = int.tryParse(_pulse.text.trim());
    if (s == null || d == null || p == null || s <= 0 || d <= 0 || p <= 0) {
      setState(() => _error = context.l10n.healthInvalidValues);
      return;
    }
    if (s <= d) {
      setState(() => _error = context.l10n.healthSysGtDia);
      return;
    }
    if (_time.text.trim().isEmpty) {
      setState(() => _error = context.l10n.healthTimeRequired);
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(healthDaoProvider).saveBp(BloodPressureLogsCompanion(
          id: Value(widget.existing?.id ?? const Uuid().v4()),
          date: Value(ymd(_date)),
          time: Value(_time.text.trim()),
          systolic: Value(s),
          diastolic: Value(d),
          pulse: Value(p),
          note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
          createdAt: Value(widget.existing?.createdAt ?? nowUtc),
          updatedAt: Value(nowUtc),
        ));
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthSaved);
    }
  }

  Future<void> _delete() async {
    await ref.read(healthDaoProvider).deleteBp(widget.existing!.id);
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _DateField(
                    date: _date, onPick: (d) => setState(() => _date = d))),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: context.l10n.healthTime,
                required: true,
                child: LmInput(controller: _time, hintText: '08:20'),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: context.l10n.healthSystolic,
                required: true,
                child: LmInput(
                  controller: _sys,
                  hintText: '120',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _revalidate(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: context.l10n.healthDiastolic,
                required: true,
                child: LmInput(
                  controller: _dia,
                  hintText: '80',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _revalidate(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: context.l10n.healthPulse,
                required: true,
                child: LmInput(
                  controller: _pulse,
                  hintText: '70',
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        Field(
          label: context.l10n.healthNote,
          child: LmInput(
              controller: _note, hintText: context.l10n.healthBpNoteHint),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton(context.l10n.actionSave,
            full: true, icon: LmIcons.check, onTap: _save),
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

// ── Medication / supplement ─────────────────────────────────────────
class _MedForm extends ConsumerStatefulWidget {
  const _MedForm({this.existing});
  final MedicationLog? existing;
  @override
  ConsumerState<_MedForm> createState() => _MedFormState();
}

class _MedFormState extends ConsumerState<_MedForm> {
  late final TextEditingController _name;
  late final TextEditingController _time;
  late final TextEditingController _dose;
  late final TextEditingController _note;
  late MedType _type;
  late MedStatus _status;
  late DateTime _date;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _time = TextEditingController(text: e?.time ?? _hm(DateTime.now()));
    _dose = TextEditingController(text: e?.dose ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _type = e?.type ?? MedType.supplement;
    _status = e?.status ?? MedStatus.taken;
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
  }

  @override
  void dispose() {
    _name.dispose();
    _time.dispose();
    _dose.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = context.l10n.healthNameRequired);
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(healthDaoProvider).saveMed(MedicationLogsCompanion(
          id: Value(widget.existing?.id ?? const Uuid().v4()),
          date: Value(ymd(_date)),
          time: Value(_time.text.trim().isEmpty ? '—' : _time.text.trim()),
          name: Value(_name.text.trim()),
          type: Value(_type),
          dose: Value(_dose.text.trim().isEmpty ? null : _dose.text.trim()),
          status: Value(_status),
          note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
          createdAt: Value(widget.existing?.createdAt ?? nowUtc),
          updatedAt: Value(nowUtc),
        ));
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthSaved);
    }
  }

  Future<void> _delete() async {
    await ref.read(healthDaoProvider).deleteMed(widget.existing!.id);
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: context.l10n.healthName,
          required: true,
          child: LmInput(
              controller: _name, hintText: context.l10n.healthMedNameHint),
        ),
        Field(
          label: context.l10n.healthType,
          required: true,
          child: Segmented(
            options: MedType.values.map((t) => localizedLabel(context, t)).toList(),
            value: localizedLabel(context, _type),
            onChanged: (l) => setState(
                () => _type = MedType.values.firstWhere((t) => localizedLabel(context, t) == l)),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: context.l10n.healthTime,
                child: LmInput(controller: _time, hintText: '08:15'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: context.l10n.healthDose,
                child: LmInput(controller: _dose, hintText: '4000 IU'),
              ),
            ),
          ],
        ),
        Field(
          label: context.l10n.healthStatus,
          required: true,
          child: Segmented(
            columns: 2,
            options: MedStatus.values.map((s) => localizedLabel(context, s)).toList(),
            value: localizedLabel(context, _status),
            onChanged: (l) => setState(() =>
                _status = MedStatus.values.firstWhere((s) => localizedLabel(context, s) == l)),
          ),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: context.l10n.healthNote,
          child: LmInput(
              controller: _note, hintText: context.l10n.healthOptional),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton(context.l10n.actionSave,
            full: true, icon: LmIcons.check, onTap: _save),
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

// ── Health event ────────────────────────────────────────────────────
class _EventForm extends ConsumerStatefulWidget {
  const _EventForm({this.existing});
  final HealthEvent? existing;
  @override
  ConsumerState<_EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<_EventForm>
    with PhotoFormMixin<_EventForm> {
  late final TextEditingController _clinic;
  late final TextEditingController _reason;
  late final TextEditingController _whatWasDone;
  late final TextEditingController _price;
  late final TextEditingController _note;
  late HealthEventType _type;
  late DentalSubtype _subtype;
  late DateTime _date;
  DateTime? _nextDate;
  String? _error;

  @override
  AttachmentEntity get photoEntity => AttachmentEntity.healthEvent;
  @override
  bool get isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _clinic = TextEditingController(text: e?.clinic ?? '');
    _reason = TextEditingController(text: e?.reason ?? '');
    _whatWasDone = TextEditingController(text: e?.whatWasDone ?? '');
    _price = TextEditingController(
        text: e?.priceCents != null ? (e!.priceCents! / 100).toStringAsFixed(2) : '');
    _note = TextEditingController(text: e?.note ?? '');
    _type = e?.type ?? HealthEventType.dentist;
    _subtype = e?.subtype ?? DentalSubtype.cleaning;
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
    _nextDate =
        e?.nextRecommendedDate != null ? _parseYmd(e!.nextRecommendedDate!) : null;
    initPhotos(e?.id ?? const Uuid().v4());
  }

  @override
  void dispose() {
    cleanupOrphansIfAbandoned();
    _clinic.dispose();
    _reason.dispose();
    _whatWasDone.dispose();
    _price.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_whatWasDone.text.trim().isEmpty) {
      setState(() => _error = context.l10n.healthWhatDoneRequired);
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    String? t(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    await ref.read(healthDaoProvider).saveEvent(HealthEventsCompanion(
          id: Value(entityId),
          date: Value(ymd(_date)),
          type: Value(_type),
          subtype: Value(_type == HealthEventType.dentist ? _subtype : null),
          clinic: Value(t(_clinic)),
          reason: Value(t(_reason)),
          whatWasDone: Value(_whatWasDone.text.trim()),
          priceCents: Value(_parseCents(_price.text)),
          nextRecommendedDate:
              Value(_nextDate != null ? ymd(_nextDate!) : null),
          note: Value(t(_note)),
          createdAt: Value(widget.existing?.createdAt ?? nowUtc),
          updatedAt: Value(nowUtc),
        ));
    committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthSaved);
    }
  }

  Future<void> _delete() async {
    await svc.deleteAllForEntity(AttachmentEntity.healthEvent, entityId);
    await ref.read(healthDaoProvider).deleteEvent(entityId);
    committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Field(
          label: context.l10n.healthType,
          required: true,
          child: Segmented(
            options: HealthEventType.values.map((t) => localizedLabel(context, t)).toList(),
            value: localizedLabel(context, _type),
            onChanged: (l) => setState(() =>
                _type = HealthEventType.values.firstWhere((t) => localizedLabel(context, t) == l)),
          ),
        ),
        if (_type == HealthEventType.dentist)
          Field(
            label: context.l10n.healthDentalSubtype,
            child: Segmented(
              options: DentalSubtype.values.map((s) => localizedLabel(context, s)).toList(),
              value: localizedLabel(context, _subtype),
              onChanged: (l) => setState(() =>
                  _subtype = DentalSubtype.values.firstWhere((s) => localizedLabel(context, s) == l)),
            ),
          ),
        Field(
          label: context.l10n.healthClinic,
          child: LmInput(
              controller: _clinic, hintText: context.l10n.healthClinicHint),
        ),
        Field(
          label: context.l10n.healthReason,
          child: LmInput(
              controller: _reason, hintText: context.l10n.healthOptional),
        ),
        Field(
          label: context.l10n.healthWhatDone,
          required: true,
          child: LmInput(
              controller: _whatWasDone,
              hintText: context.l10n.healthWhatDoneHint),
        ),
        Field(
          label: context.l10n.healthPrice,
          hint: '€',
          child: LmInput(
            controller: _price,
            hintText: '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        _OptionalDateField(
          label: context.l10n.healthNextRecommendedDate,
          date: _nextDate,
          onPick: (d) => setState(() => _nextDate = d),
          onClear: () => setState(() => _nextDate = null),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: context.l10n.healthNote,
          child: LmTextArea(
              controller: _note, hintText: context.l10n.healthOptional),
        ),
        Field(
          label: context.l10n.healthPhotos,
          child: MultiPhotoField(
            photos: photos,
            svc: svc,
            onAdd: addPhotos,
            onRemove: removePhoto,
          ),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton(context.l10n.actionSave,
            full: true, icon: LmIcons.check, onTap: _save),
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

// ── Lab test ────────────────────────────────────────────────────────
class _LabForm extends ConsumerStatefulWidget {
  const _LabForm({this.existing});
  final LabTest? existing;
  @override
  ConsumerState<_LabForm> createState() => _LabFormState();
}

class _LabFormState extends ConsumerState<_LabForm>
    with PhotoFormMixin<_LabForm> {
  late final TextEditingController _lab;
  late final TextEditingController _reason;
  late final TextEditingController _results;
  late final TextEditingController _note;
  late DateTime _date;
  String? _error;

  @override
  AttachmentEntity get photoEntity => AttachmentEntity.labTest;
  @override
  bool get isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _lab = TextEditingController(text: e?.lab ?? '');
    _reason = TextEditingController(text: e?.reason ?? '');
    _results = TextEditingController(text: e?.resultsText ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _date = e != null ? _parseYmd(e.date) : DateTime.now();
    initPhotos(e?.id ?? const Uuid().v4());
  }

  @override
  void dispose() {
    cleanupOrphansIfAbandoned();
    _lab.dispose();
    _reason.dispose();
    _results.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_lab.text.trim().isEmpty || _reason.text.trim().isEmpty) {
      setState(() => _error = context.l10n.healthLabRequired);
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(healthDaoProvider).saveLab(LabTestsCompanion(
          id: Value(entityId),
          date: Value(ymd(_date)),
          lab: Value(_lab.text.trim()),
          reason: Value(_reason.text.trim()),
          resultsText:
              Value(_results.text.trim().isEmpty ? null : _results.text.trim()),
          note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
          createdAt: Value(widget.existing?.createdAt ?? nowUtc),
          updatedAt: Value(nowUtc),
        ));
    committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthSaved);
    }
  }

  Future<void> _delete() async {
    await svc.deleteAllForEntity(AttachmentEntity.labTest, entityId);
    await ref.read(healthDaoProvider).deleteLab(entityId);
    committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, context.l10n.healthDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: context.l10n.healthLab,
          required: true,
          child: LmInput(
              controller: _lab, hintText: context.l10n.healthLabHint),
        ),
        Field(
          label: context.l10n.healthReason,
          required: true,
          child: LmInput(
              controller: _reason, hintText: context.l10n.healthLabReasonHint),
        ),
        Field(
          label: context.l10n.healthResults,
          child: LmTextArea(
              controller: _results,
              mono: true,
              hintText: context.l10n.healthResultsHint),
        ),
        Field(
          label: context.l10n.healthNote,
          child: LmInput(
              controller: _note, hintText: context.l10n.healthOptional),
        ),
        Field(
          label: context.l10n.healthPhotos,
          child: MultiPhotoField(
            photos: photos,
            svc: svc,
            onAdd: addPhotos,
            onRemove: removePhoto,
          ),
        ),
        if (_error != null) _ErrorText(_error!),
        const SizedBox(height: 4),
        LmButton(context.l10n.actionSave,
            full: true, icon: LmIcons.check, onTap: _save),
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

// ── Shared sub-widgets ──────────────────────────────────────────────
class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onPick});
  final DateTime date;
  final ValueChanged<DateTime> onPick;
  @override
  Widget build(BuildContext context) {
    return Field(
      label: context.l10n.healthDate,
      required: true,
      child: _DateBox(
        text: dmyDate(date),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) onPick(picked);
        },
      ),
    );
  }
}

class _OptionalDateField extends StatelessWidget {
  const _OptionalDateField({
    required this.label,
    required this.date,
    required this.onPick,
    required this.onClear,
  });
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onPick;
  final VoidCallback onClear;
  @override
  Widget build(BuildContext context) {
    return Field(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: _DateBox(
              text: date != null ? dmyDate(date!) : '—',
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) onPick(picked);
              },
            ),
          ),
          if (date != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: LmIcon(LmIcons.close, size: 18, color: AppColors.textDim),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadii.input),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(text, style: AppText.body.copyWith(fontSize: 15)),
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
