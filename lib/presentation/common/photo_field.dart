// Shared single-photo (0–1) attachment field used by the photo-bearing forms
// (Food, Activities, Daily, …). A dashed dropzone when empty; a thumbnail +
// "remove" when set. Tapping the thumbnail opens the full image. Files are
// resolved through AttachmentService (technical-spec §5.1).

import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/photo.dart';
import '../../data/database.dart';
import '../../services/attachment_service.dart';

class SinglePhotoField extends StatelessWidget {
  const SinglePhotoField({
    super.key,
    required this.photos,
    required this.svc,
    required this.onAdd,
    required this.onRemove,
    this.addLabel = 'Добави снимка',
  });

  final List<Attachment> photos;
  final AttachmentService svc;
  final VoidCallback onAdd;
  final void Function(Attachment) onRemove;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return PhotoAdd(label: addLabel, onTap: onAdd);
    final a = photos.first;
    return Row(
      children: [
        AttachmentThumb(svc: svc, attachment: a, size: 72),
        const SizedBox(width: 12),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onRemove(a),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.redSoft,
              borderRadius: BorderRadius.circular(AppRadii.input),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LmIcon(LmIcons.trash, size: 16, color: AppColors.red),
                SizedBox(width: 8),
                Text('Премахни',
                    style: TextStyle(
                        fontFamily: AppText.sans,
                        fontSize: 13,
                        color: AppColors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A multi-photo (0–many) attachment field: a wrap of thumbnails (each with a
/// remove badge) followed by an "add more" dashed tile.
class MultiPhotoField extends StatelessWidget {
  const MultiPhotoField({
    super.key,
    required this.photos,
    required this.svc,
    required this.onAdd,
    required this.onRemove,
    this.addLabel = 'Добави снимки',
  });

  final List<Attachment> photos;
  final AttachmentService svc;
  final VoidCallback onAdd;
  final void Function(Attachment) onRemove;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return PhotoAdd(label: addLabel, multi: true, onTap: onAdd);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final a in photos)
          Stack(
            children: [
              AttachmentThumb(svc: svc, attachment: a, size: 84),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onRemove(a),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const LmIcon(LmIcons.close, size: 14, color: AppColors.text),
                  ),
                ),
              ),
            ],
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onAdd,
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0x05FFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderHi),
            ),
            child: const LmIcon(LmIcons.plus, size: 22, color: AppColors.textFaint),
          ),
        ),
      ],
    );
  }
}

/// A rounded attachment thumbnail; tapping opens the full image in a viewer.
class AttachmentThumb extends StatelessWidget {
  const AttachmentThumb({
    super.key,
    required this.svc,
    required this.attachment,
    this.size = 72,
  });
  final AttachmentService svc;
  final Attachment attachment;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFull(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: size,
          height: size,
          child: FutureBuilder<String>(
            future: svc.absolutePath(attachment.thumbPath),
            builder: (context, snap) => snap.hasData
                ? Image.file(File(snap.data!), fit: BoxFit.cover)
                : const ColoredBox(color: AppColors.card),
          ),
        ),
      ),
    );
  }

  Future<void> _openFull(BuildContext context) async {
    final full = await svc.absolutePath(attachment.filePath);
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.of(ctx).pop(),
        child: Container(
          color: Colors.black.withValues(alpha: 0.92),
          alignment: Alignment.center,
          child: InteractiveViewer(child: Image.file(File(full))),
        ),
      ),
    );
  }
}
