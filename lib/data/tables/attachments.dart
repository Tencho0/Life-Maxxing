import 'package:drift/drift.dart';
import '../converters.dart';

/// Polymorphic attachment metadata (spec §23/§26.6). Files live on disk; this
/// row stores relative paths to the full image and its thumbnail plus size.
/// Cardinality (0/1 vs many) is enforced by AttachmentService, not the schema.
@DataClassName('Attachment')
@TableIndex(name: 'idx_attachments_entity', columns: {#entityType, #entityId})
class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text().map(attachmentEntityConverter)();
  TextColumn get entityId => text()();
  TextColumn get role => text().map(attachmentRoleConverter)();
  TextColumn get filePath => text()(); // relative, full image
  TextColumn get thumbPath => text()(); // relative, ~320px thumbnail
  TextColumn get fileType => text()(); // mime, e.g. image/jpeg
  TextColumn get originalFileName => text().nullable()();
  IntColumn get fileSize => integer()(); // bytes of the full image
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
