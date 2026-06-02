// Shared 0–many photo handling for ConsumerStatefulWidget forms (Health
// events/labs, Bucket items/experiences). Owns the entity's attachments list
// plus load/add/remove, and cleans up orphan files if a NEW owner is abandoned
// without saving (technical-spec §5.1).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';

mixin PhotoFormMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final String entityId;
  late final AttachmentService svc;
  List<Attachment> photos = const [];
  bool committed = false;

  /// Which entity these photos belong to.
  AttachmentEntity get photoEntity;

  /// Whether the owning record is new (no existing row yet).
  bool get isNew;

  void initPhotos(String id) {
    entityId = id;
    svc = ref.read(attachmentServiceProvider);
    if (!isNew) reloadPhotos();
  }

  Future<void> reloadPhotos() async {
    final ps = await ref
        .read(databaseProvider)
        .attachmentsDao
        .forEntity(photoEntity, entityId);
    if (mounted) setState(() => photos = ps);
  }

  Future<void> addPhotos() async {
    final added = await svc.pickMultiAndAdd(
        entity: photoEntity, entityId: entityId, role: AttachmentRole.photo);
    if (added.isNotEmpty) await reloadPhotos();
  }

  Future<void> removePhoto(Attachment a) async {
    await svc.removeAttachment(a);
    await reloadPhotos();
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
