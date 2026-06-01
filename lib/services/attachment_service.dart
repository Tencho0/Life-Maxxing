// AttachmentService — the single write path for photo attachments, so the
// image pipeline, cardinality rules, and "delete-cascades-files" all live in
// one place (technical-spec §5.1, locked decisions §4).
//
//  • Pipeline: pick (image_picker) → compress ≤1600px / Q80 (full) + ≤320px /
//    Q70 (thumbnail) → write both under `attachments/<entity-folder>/` in the
//    app documents dir → insert a metadata row (relative posix paths, size,
//    dims, role, sortOrder).
//  • Cardinality (enforced here, not in the schema): meal/activity `photo`,
//    daily `main`, trip `cover` are single (adding replaces + deletes old
//    files); health_event/lab_test/bucket_item/bucket_experience `photo` and
//    trip `gallery` are many (appended, sortOrder = max+1).
//  • Delete: the attachments table is polymorphic (no FK), so SQLite never
//    removes attachment files; every record delete must route here. Deleting a
//    bucket item must also clean its experience's files (its row cascades, the
//    files do not) — `deleteForBucketItem` handles both.

import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../data/daos.dart';
import '../data/database.dart';
import '../domain/enums.dart';
import 'image_processor.dart';

/// Picks a single image and returns its file path (null if cancelled).
typedef PickSingle = Future<String?> Function(ImageSource source);

/// Picks multiple images and returns their file paths (empty if cancelled).
typedef PickMulti = Future<List<String>> Function();

class AttachmentService {
  AttachmentService(
    this._dao, {
    ImageProcessor imageProcessor = const FlutterImageProcessor(),
    Future<Directory> Function()? docsDir,
    String Function()? idGen,
    DateTime Function()? clock,
    PickSingle? pickSingle,
    PickMulti? pickMulti,
  })  : _img = imageProcessor,
        _docsDir = docsDir ?? getApplicationDocumentsDirectory,
        _idGen = idGen ?? (() => const Uuid().v4()),
        _clock = clock ?? DateTime.now,
        _pickSingle = pickSingle ?? _defaultPickSingle,
        _pickMulti = pickMulti ?? _defaultPickMulti;

  final AttachmentsDao _dao;
  final ImageProcessor _img;
  final Future<Directory> Function() _docsDir;
  final String Function() _idGen;
  final DateTime Function() _clock;
  final PickSingle _pickSingle;
  final PickMulti _pickMulti;

  // Approved pipeline parameters (technical-spec §5.1).
  static const int _fullMaxEdge = 1600;
  static const int _fullQuality = 80;
  static const int _thumbMaxEdge = 320;
  static const int _thumbQuality = 70;
  static const String _jpegMime = 'image/jpeg';

  // ── Picking + add (UI entry points) ────────────────────────────────

  /// Pick one image and attach it. Returns null if the user cancelled.
  Future<Attachment?> pickAndAdd({
    required AttachmentEntity entity,
    required String entityId,
    required AttachmentRole role,
    ImageSource source = ImageSource.gallery,
  }) async {
    final path = await _pickSingle(source);
    if (path == null) return null;
    return addFromFile(
      entity: entity,
      entityId: entityId,
      role: role,
      sourcePath: path,
      originalFileName: p.basename(path),
    );
  }

  /// Pick many images and attach them all (for `many`-cardinality roles).
  Future<List<Attachment>> pickMultiAndAdd({
    required AttachmentEntity entity,
    required String entityId,
    required AttachmentRole role,
  }) async {
    final paths = await _pickMulti();
    final added = <Attachment>[];
    for (final path in paths) {
      added.add(await addFromFile(
        entity: entity,
        entityId: entityId,
        role: role,
        sourcePath: path,
        originalFileName: p.basename(path),
      ));
    }
    return added;
  }

  // ── Core pipeline ──────────────────────────────────────────────────

  /// Run the image pipeline on [sourcePath] and attach the result to
  /// [entity]/[entityId] with [role]. For single-cardinality roles the existing
  /// attachment of that role is removed first (files + row). Returns the new
  /// [Attachment].
  Future<Attachment> addFromFile({
    required AttachmentEntity entity,
    required String entityId,
    required AttachmentRole role,
    required String sourcePath,
    String? originalFileName,
  }) async {
    final single = _isSingleton(entity, role);
    if (single) {
      for (final old in await _dao.forEntity(entity, entityId)) {
        if (old.role == role) {
          await _deleteFiles(old);
          await _dao.deleteById(old.id);
        }
      }
    }

    final full =
        await _img.process(sourcePath, maxEdge: _fullMaxEdge, quality: _fullQuality);
    final thumb = await _img.process(sourcePath,
        maxEdge: _thumbMaxEdge, quality: _thumbQuality);

    final id = _idGen();
    final folder = entity.folder;
    final relFull = p.posix.join('attachments', folder, '$id.jpg');
    final relThumb = p.posix.join('attachments', folder, '${id}_thumb.jpg');

    final base = await _docsDir();
    final dir = Directory(p.join(base.path, 'attachments', folder));
    await dir.create(recursive: true);
    await File(p.join(dir.path, '$id.jpg')).writeAsBytes(full.bytes, flush: true);
    await File(p.join(dir.path, '${id}_thumb.jpg'))
        .writeAsBytes(thumb.bytes, flush: true);

    final sortOrder =
        single ? 0 : _nextSortOrder(await _dao.forEntity(entity, entityId));

    await _dao.save(AttachmentsCompanion.insert(
      id: id,
      entityType: entity,
      entityId: entityId,
      role: role,
      filePath: relFull,
      thumbPath: relThumb,
      fileType: _jpegMime,
      originalFileName: Value(originalFileName),
      fileSize: full.bytes.length,
      width: Value(full.width),
      height: Value(full.height),
      sortOrder: Value(sortOrder),
      createdAt: _clock().toUtc(),
    ));

    return (await _dao.forEntity(entity, entityId))
        .firstWhere((a) => a.id == id);
  }

  // ── Delete ─────────────────────────────────────────────────────────

  /// Remove one attachment: its files (full + thumb) and its row.
  Future<void> removeAttachment(Attachment a) async {
    await _deleteFiles(a);
    await _dao.deleteById(a.id);
  }

  /// Remove every attachment for a record (files + rows). Call this before
  /// deleting the owning record so no files orphan on disk (§4.4).
  Future<void> deleteAllForEntity(
      AttachmentEntity entity, String entityId) async {
    for (final a in await _dao.forEntity(entity, entityId)) {
      await _deleteFiles(a);
      await _dao.deleteById(a.id);
    }
  }

  /// Delete a bucket item's attachments **and** its experience's attachments.
  /// The `bucket_experiences` row cascades when the item is deleted, but its
  /// photo files (and polymorphic attachment rows) do not — clean both here so
  /// nothing orphans (technical-spec §5.1).
  Future<void> deleteForBucketItem(String itemId, {String? experienceId}) async {
    await deleteAllForEntity(AttachmentEntity.bucketItem, itemId);
    if (experienceId != null) {
      await deleteAllForEntity(AttachmentEntity.bucketExperience, experienceId);
    }
  }

  /// Resolve a stored relative (posix) path to an absolute, native-separator
  /// path under the app documents dir — for displaying an attachment's image.
  Future<String> absolutePath(String relativePath) async {
    final base = await _docsDir();
    return p.join(base.path, p.joinAll(p.posix.split(relativePath)));
  }

  // ── Internals ──────────────────────────────────────────────────────

  /// Single-cardinality (entity, role) pairs: replacing deletes the old file.
  bool _isSingleton(AttachmentEntity entity, AttachmentRole role) {
    switch (role) {
      case AttachmentRole.main: // daily_log photo
      case AttachmentRole.cover: // trip cover
        return true;
      case AttachmentRole.gallery: // trip gallery
        return false;
      case AttachmentRole.photo:
        return entity == AttachmentEntity.meal ||
            entity == AttachmentEntity.activity;
    }
  }

  int _nextSortOrder(List<Attachment> existing) => existing.isEmpty
      ? 0
      : existing.map((a) => a.sortOrder).reduce((a, b) => a > b ? a : b) + 1;

  Future<void> _deleteFiles(Attachment a) async {
    final base = await _docsDir();
    for (final rel in [a.filePath, a.thumbPath]) {
      final f = File(p.join(base.path, p.joinAll(p.posix.split(rel))));
      if (await f.exists()) await f.delete();
    }
  }

  static Future<String?> _defaultPickSingle(ImageSource source) async {
    final x = await ImagePicker().pickImage(source: source, imageQuality: 100);
    return x?.path;
  }

  static Future<List<String>> _defaultPickMulti() async {
    final xs = await ImagePicker().pickMultiImage(imageQuality: 100);
    return xs.map((x) => x.path).toList();
  }
}
