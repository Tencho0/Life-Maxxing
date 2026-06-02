// Trip create+edit form (bottom sheet). Carries a single cover (role=cover,
// replaceable) plus a many-photo gallery (role=gallery) via AttachmentService.
// Required: title + destination + dates + overall; toDate must be ≥ fromDate
// (spec §21). Deleting a trip removes all its photo files + rows.

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
import '../../core/widgets/yes_no.dart';
import '../../core/format/dates.dart';
import '../../data/database.dart';
import '../../data/daos.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';
import '../common/photo_field.dart';
import 'trip_providers.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime _parseYmd(String s) => DateTime.parse(s);

/// Delete a trip and all of its photo files + attachment rows (cover + gallery).
Future<void> deleteTrip(
    TripsDao dao, AttachmentService svc, String tripId) async {
  await svc.deleteAllForEntity(AttachmentEntity.trip, tripId);
  await dao.deleteById(tripId);
}

void showTripSheet(BuildContext context, {Trip? existing}) {
  showLmSheet(
    context,
    title: existing == null ? 'Ново пътуване' : 'Редакция на пътуване',
    subtitle: 'заглавие, дестинация, период, оценка',
    child: _TripForm(existing: existing),
  );
}

class _TripForm extends ConsumerStatefulWidget {
  const _TripForm({this.existing});
  final Trip? existing;
  @override
  ConsumerState<_TripForm> createState() => _TripFormState();
}

class _TripFormState extends ConsumerState<_TripForm> {
  late final TextEditingController _title;
  late final TextEditingController _destination;
  late final TextEditingController _comment;
  late DateTime _from;
  late DateTime _to;
  late int _overall;
  int? _fun;
  int? _food;
  int? _sights;
  int? _value;
  bool? _wouldRepeat;
  late final String _tripId;
  late final AttachmentService _svc;
  List<Attachment> _photos = const [];
  bool _committed = false;
  String? _error;

  List<Attachment> get _cover =>
      _photos.where((a) => a.role == AttachmentRole.cover).toList();
  List<Attachment> get _gallery =>
      _photos.where((a) => a.role == AttachmentRole.gallery).toList();

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _destination = TextEditingController(text: e?.destination ?? '');
    _comment = TextEditingController(text: e?.comment ?? '');
    _from = e != null ? _parseYmd(e.fromDate) : DateTime.now();
    _to = e != null ? _parseYmd(e.toDate) : DateTime.now();
    _overall = e?.overall ?? 8;
    _fun = e?.fun;
    _food = e?.food;
    _sights = e?.sights;
    _value = e?.value;
    _wouldRepeat = e?.wouldRepeat;
    _tripId = e?.id ?? const Uuid().v4();
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
    _title.dispose();
    _destination.dispose();
    _comment.dispose();
    super.dispose();
  }

  Future<void> _loadPhotos() async {
    final ps = await ref
        .read(databaseProvider)
        .attachmentsDao
        .forEntity(AttachmentEntity.trip, _tripId);
    if (mounted) setState(() => _photos = ps);
  }

  Future<void> _addCover() async {
    final a = await _svc.pickAndAdd(
        entity: AttachmentEntity.trip,
        entityId: _tripId,
        role: AttachmentRole.cover);
    if (a != null) await _loadPhotos();
  }

  Future<void> _addGallery() async {
    final added = await _svc.pickMultiAndAdd(
        entity: AttachmentEntity.trip,
        entityId: _tripId,
        role: AttachmentRole.gallery);
    if (added.isNotEmpty) await _loadPhotos();
  }

  Future<void> _removePhoto(Attachment a) async {
    await _svc.removeAttachment(a);
    await _loadPhotos();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _destination.text.trim().isEmpty) {
      setState(() => _error = 'Заглавие и дестинация са задължителни');
      return;
    }
    if (_ymd(_to).compareTo(_ymd(_from)) < 0) {
      setState(() => _error = 'Крайната дата трябва да е след началната');
      return;
    }
    final nowUtc = DateTime.now().toUtc();
    await ref.read(tripsDaoProvider).save(TripsCompanion(
          id: Value(_tripId),
          title: Value(_title.text.trim()),
          destination: Value(_destination.text.trim()),
          fromDate: Value(_ymd(_from)),
          toDate: Value(_ymd(_to)),
          overall: Value(_overall),
          fun: Value(_fun),
          food: Value(_food),
          sights: Value(_sights),
          value: Value(_value),
          wouldRepeat: Value(_wouldRepeat),
          comment:
              Value(_comment.text.trim().isEmpty ? null : _comment.text.trim()),
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
    await deleteTrip(ref.read(tripsDaoProvider), _svc, _tripId);
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
          label: 'Заглавие',
          required: true,
          child: LmInput(controller: _title, hintText: 'напр. Уикенд в Рим'),
        ),
        Field(
          label: 'Дестинация',
          required: true,
          child: LmInput(controller: _destination, hintText: 'напр. Рим, Италия'),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _DateField(
                    label: 'От дата',
                    date: _from,
                    onPick: (d) => setState(() => _from = d))),
            const SizedBox(width: 10),
            Expanded(
                child: _DateField(
                    label: 'До дата',
                    date: _to,
                    onPick: (d) => setState(() => _to = d))),
          ],
        ),
        Field(
          label: 'Обща оценка',
          required: true,
          hint: '$_overall / 10',
          child: Scale10(
              value: _overall,
              color: AppColors.amber,
              onChanged: (v) => setState(() => _overall = v)),
        ),
        _RatingField('Забавление', _fun, (v) => setState(() => _fun = v)),
        _RatingField('Храна', _food, (v) => setState(() => _food = v)),
        _RatingField('Забележителности', _sights, (v) => setState(() => _sights = v)),
        _RatingField('Стойност', _value, (v) => setState(() => _value = v)),
        Field(
          label: 'Би ли повторил?',
          child: YesNo(
              value: _wouldRepeat,
              onChanged: (v) => setState(() => _wouldRepeat = v)),
        ),
        Field(
          label: 'Коментар',
          child: LmTextArea(controller: _comment, hintText: 'как беше?'),
        ),
        Field(
          label: 'Cover снимка',
          child: SinglePhotoField(
            photos: _cover,
            svc: _svc,
            onAdd: _addCover,
            onRemove: _removePhoto,
            addLabel: 'Добави корица',
          ),
        ),
        Field(
          label: 'Галерия',
          child: MultiPhotoField(
            photos: _gallery,
            svc: _svc,
            onAdd: _addGallery,
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

class _RatingField extends StatelessWidget {
  const _RatingField(this.label, this.value, this.onChanged);
  final String label;
  final int? value;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Field(
        label: label,
        child: Scale10(value: value, color: AppColors.amber, onChanged: onChanged),
      );
}

class _DateField extends StatelessWidget {
  const _DateField(
      {required this.label, required this.date, required this.onPick});
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onPick;
  @override
  Widget build(BuildContext context) {
    return Field(
      label: label,
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
