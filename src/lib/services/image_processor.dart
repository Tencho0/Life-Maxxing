// The image pipeline step of AttachmentService, isolated behind an interface so
// the service can be unit-tested with a fake (real compression needs the native
// plugin / a device). See technical-spec §5.1.

import 'dart:typed_data';

import 'package:flutter/painting.dart' show decodeImageFromList;
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Result of running the pipeline on a source image: re-encoded JPEG bytes plus
/// the resulting pixel dimensions.
class ProcessedImage {
  const ProcessedImage(
      {required this.bytes, required this.width, required this.height});
  final Uint8List bytes;
  final int width;
  final int height;
}

/// Resizes + re-encodes a source image to JPEG. Production code uses
/// [FlutterImageProcessor]; tests inject a deterministic fake.
abstract interface class ImageProcessor {
  /// Scale [sourcePath] so its long edge is ≤ [maxEdge] and re-encode as JPEG
  /// at [quality] (0–100). Returns the encoded bytes and final dimensions.
  Future<ProcessedImage> process(String sourcePath,
      {required int maxEdge, required int quality});
}

/// Production [ImageProcessor] backed by `flutter_image_compress`. Passing equal
/// `minWidth`/`minHeight` makes the plugin fit the image inside a `maxEdge`
/// square box while preserving aspect ratio — i.e. long edge ≤ `maxEdge`.
class FlutterImageProcessor implements ImageProcessor {
  const FlutterImageProcessor();

  @override
  Future<ProcessedImage> process(String sourcePath,
      {required int maxEdge, required int quality}) async {
    final bytes = await FlutterImageCompress.compressWithFile(
      sourcePath,
      minWidth: maxEdge,
      minHeight: maxEdge,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    if (bytes == null) {
      throw StateError('Image compression failed for $sourcePath');
    }
    final decoded = await decodeImageFromList(bytes);
    try {
      return ProcessedImage(
          bytes: bytes, width: decoded.width, height: decoded.height);
    } finally {
      decoded.dispose();
    }
  }
}
