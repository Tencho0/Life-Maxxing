// Backup providers: the BackupService (bound to the app database) plus a
// session-level "last created" timestamp for the screen's status line. V1 has
// no settings store, so the last-backup time is tracked only for this run.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../services/backup_service.dart';

final backupServiceProvider =
    Provider<BackupService>((ref) => BackupService(ref.watch(databaseProvider)));

/// When the most recent backup was created this session (null if none yet).
final lastBackupProvider = StateProvider<DateTime?>((_) => null);
