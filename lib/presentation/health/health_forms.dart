// Health forms (bottom sheets): BP, Medication, Health-event, Lab test.
// BP/Med write through HealthDao; Event/Lab additionally carry 0–many photos via
// AttachmentService (PhotoFormMixin handles load/add/remove + abandon-cleanup).
// Rules: BP requires sys > dia (live); event subtype applies only to the dentist
// type; lab requires lab + reason (spec §12–§15).

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
import '../../core/widgets/segmented.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';
import '../common/photo_field.dart';
import 'health_providers.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

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
        title: existing == null ? 'Кръвно и пулс' : 'Редакция — кръвно',
        subtitle: 'дата, час и трите стойности са задължителни',
        child: _BpForm(existing: existing));

void showMedSheet(BuildContext context, {MedicationLog? existing}) =>
    showLmSheet(context,
        title: existing == null ? 'Медикамент / добавка' : 'Редакция — добавка',
        subtitle: 'име, тип и статус са задължителни',
        child: _MedForm(existing: existing));

void showEventSheet(BuildContext context, {HealthEvent? existing}) =>
    showLmSheet(context,
        title: existing == null ? 'Здравно събитие' : 'Редакция — събитие',
        subtitle: 'какво е направено е задължително',
        child: _EventForm(existing: existing));

void showLabSheet(BuildContext context, {LabTest? existing}) =>
    showLmSheet(context,
        title: existing == null ? 'Изследване' : 'Редакция — изследване',
        subtitle: 'лаборатория и причина са задължителни',
        child: _LabForm(existing: existing));

// ── Photo mixin (events / labs: 0–many) ─────────────────────────────
mixin _PhotoFormMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final String entityId;
  late final AttachmentService svc;
  List<Attachment> photos = const [];
  bool committed = false;

  AttachmentEntity get photoEntity;
  bool get isNew;

  void initPhotos(String id) {
    entityId = id;
    svc = ref.read(attachmentServiceProvider);
    if (!isNew) _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final ps = await ref
        .read(databaseProvider)
        .attachmentsDao
        .forEntity(photoEntity, entityId);
    if (mounted) setState(() => photos = ps);
  }

  Future<void> addPhotos() async {
    final added = await svc.pickMultiAndAdd(
        entity: photoEntity, entityId: entityId, role: AttachmentRole.photo);
    if (added.isNotEmpty) await _loadPhotos();
  }

  Future<void> removePhoto(Attachment a) async {
    await svc.removeAttachment(a);
    await _loadPhotos();
  }

  void cleanupOrphansIfAbandoned() {
    if (!committed && isNew && photos.isNotEmpty) {
      final s = svc;
      final orphans = List<Attachment>.of(photos);
      Future<void>(() async {
        for (final a in orphans) {
          try {
            await s.removeAttachment(a);
          } catch (_) {}
        }
      });
    }
  }
}

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
    setState(() => _error = (s != null && d != null && s <= d)
        ? 'Систоличното трябва да е по-голямо от диастоличното'
        : null);
  }

  Future<void> _save() async {
    final s = int.tryParse(_sys.text.trim());
    final d = int.tryParse(_dia.text.trim());
    final p = int.tryParse(_pulse.text.trim());
    if (s == null || d == null || p == null || s <= 0 || d <= 0 || p <= 0) {
      setState(() => _error = 'Въведи валидни стойности');
      return;
    }
    if (s <= d) {
      setState(() =>
          _error = 'Систоличното трябва да е по-голямо от диастоличното');
      return;
    }
    if (_time.text.trim().isEmpty) {
      setState(() => _error = 'Часът е задължителен');
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(healthDaoProvider).saveBp(BloodPressureLogsCompanion(
          id: Value(widget.existing?.id ?? const Uuid().v4()),
          date: Value(_ymd(_date)),
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
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await ref.read(healthDaoProvider).deleteBp(widget.existing!.id);
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _DateField(
                    date: _date, onPick: (d) => setState(() => _date = d))),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: 'Час',
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
                label: 'Систолно',
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
                label: 'Диастолно',
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
                label: 'Пулс',
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
          label: 'Бележка',
          child: LmInput(controller: _note, hintText: 'напр. сутрин, в покой'),
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
      setState(() => _error = 'Името е задължително');
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(healthDaoProvider).saveMed(MedicationLogsCompanion(
          id: Value(widget.existing?.id ?? const Uuid().v4()),
          date: Value(_ymd(_date)),
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
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await ref.read(healthDaoProvider).deleteMed(widget.existing!.id);
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
          label: 'Име',
          required: true,
          child: LmInput(controller: _name, hintText: 'напр. Витамин D3'),
        ),
        Field(
          label: 'Тип',
          required: true,
          child: Segmented(
            options: MedType.values.map((t) => t.label).toList(),
            value: _type.label,
            onChanged: (l) => setState(
                () => _type = MedType.values.firstWhere((t) => t.label == l)),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: 'Час',
                child: LmInput(controller: _time, hintText: '08:15'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Field(
                label: 'Доза',
                child: LmInput(controller: _dose, hintText: '4000 IU'),
              ),
            ),
          ],
        ),
        Field(
          label: 'Статус',
          required: true,
          child: Segmented(
            columns: 2,
            options: MedStatus.values.map((s) => s.label).toList(),
            value: _status.label,
            onChanged: (l) => setState(() =>
                _status = MedStatus.values.firstWhere((s) => s.label == l)),
          ),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: 'Бележка',
          child: LmInput(controller: _note, hintText: 'незадължително'),
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

// ── Health event ────────────────────────────────────────────────────
class _EventForm extends ConsumerStatefulWidget {
  const _EventForm({this.existing});
  final HealthEvent? existing;
  @override
  ConsumerState<_EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<_EventForm>
    with _PhotoFormMixin<_EventForm> {
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
      setState(() => _error = 'Полето „какво е направено“ е задължително');
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    String? t(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    await ref.read(healthDaoProvider).saveEvent(HealthEventsCompanion(
          id: Value(entityId),
          date: Value(_ymd(_date)),
          type: Value(_type),
          subtype: Value(_type == HealthEventType.dentist ? _subtype : null),
          clinic: Value(t(_clinic)),
          reason: Value(t(_reason)),
          whatWasDone: Value(_whatWasDone.text.trim()),
          priceCents: Value(_parseCents(_price.text)),
          nextRecommendedDate:
              Value(_nextDate != null ? _ymd(_nextDate!) : null),
          note: Value(t(_note)),
          createdAt: Value(widget.existing?.createdAt ?? nowUtc),
          updatedAt: Value(nowUtc),
        ));
    committed = true;
    if (mounted) {
      Navigator.pop(context);
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await svc.deleteAllForEntity(AttachmentEntity.healthEvent, entityId);
    await ref.read(healthDaoProvider).deleteEvent(entityId);
    committed = true;
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
          label: 'Тип',
          required: true,
          child: Segmented(
            options: HealthEventType.values.map((t) => t.label).toList(),
            value: _type.label,
            onChanged: (l) => setState(() =>
                _type = HealthEventType.values.firstWhere((t) => t.label == l)),
          ),
        ),
        if (_type == HealthEventType.dentist)
          Field(
            label: 'Вид (зъболекар)',
            child: Segmented(
              options: DentalSubtype.values.map((s) => s.label).toList(),
              value: _subtype.label,
              onChanged: (l) => setState(() =>
                  _subtype = DentalSubtype.values.firstWhere((s) => s.label == l)),
            ),
          ),
        Field(
          label: 'Клиника / лекар',
          child: LmInput(controller: _clinic, hintText: 'напр. Д-р Иванова'),
        ),
        Field(
          label: 'Причина',
          child: LmInput(controller: _reason, hintText: 'незадължително'),
        ),
        Field(
          label: 'Какво е направено',
          required: true,
          child: LmInput(
              controller: _whatWasDone, hintText: 'напр. Профилактично почистване'),
        ),
        Field(
          label: 'Цена',
          hint: '€',
          child: LmInput(
            controller: _price,
            hintText: '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        _OptionalDateField(
          label: 'Следваща препоръчана дата',
          date: _nextDate,
          onPick: (d) => setState(() => _nextDate = d),
          onClear: () => setState(() => _nextDate = null),
        ),
        _DateField(date: _date, onPick: (d) => setState(() => _date = d)),
        Field(
          label: 'Бележка',
          child: LmTextArea(controller: _note, hintText: 'незадължително'),
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

// ── Lab test ────────────────────────────────────────────────────────
class _LabForm extends ConsumerStatefulWidget {
  const _LabForm({this.existing});
  final LabTest? existing;
  @override
  ConsumerState<_LabForm> createState() => _LabFormState();
}

class _LabFormState extends ConsumerState<_LabForm>
    with _PhotoFormMixin<_LabForm> {
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
      setState(() => _error = 'Лаборатория и причина са задължителни');
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(healthDaoProvider).saveLab(LabTestsCompanion(
          id: Value(entityId),
          date: Value(_ymd(_date)),
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
      showLmToast(context, 'Записано успешно');
    }
  }

  Future<void> _delete() async {
    await svc.deleteAllForEntity(AttachmentEntity.labTest, entityId);
    await ref.read(healthDaoProvider).deleteLab(entityId);
    committed = true;
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
          label: 'Лаборатория',
          required: true,
          child: LmInput(controller: _lab, hintText: 'напр. Цибалаб'),
        ),
        Field(
          label: 'Причина',
          required: true,
          child: LmInput(controller: _reason, hintText: 'напр. Хормони'),
        ),
        Field(
          label: 'Резултати',
          child: LmTextArea(
              controller: _results, mono: true, hintText: 'свободен текст'),
        ),
        Field(
          label: 'Бележка',
          child: LmInput(controller: _note, hintText: 'незадължително'),
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
      child: _DateBox(
        text: _ymd(date),
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
              text: date != null ? _ymd(date!) : '—',
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
