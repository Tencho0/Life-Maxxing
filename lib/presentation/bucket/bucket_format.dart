// Bucket formatting — color accents for priority and status.

import 'package:flutter/widgets.dart';
import '../../core/theme/tokens.dart';
import '../../domain/enums.dart';

Color bucketPriorityColor(BucketPriority p) => switch (p) {
      BucketPriority.high => AppColors.red,
      BucketPriority.medium => AppColors.amber,
      BucketPriority.low => AppColors.textDim,
    };

Color bucketStatusColor(BucketStatus s) => switch (s) {
      BucketStatus.idea => AppColors.accent,
      BucketStatus.planned => AppColors.purple,
      BucketStatus.completed => AppColors.green,
      BucketStatus.abandoned => AppColors.textFaint,
    };
