import 'dart:ui' show Locale;

import '../data/daos.dart';

/// App preferences persisted in the drift `settings` KV table — the UI locale
/// and the user's display name (shown in the home greeting). Both are device
/// preferences, deliberately excluded from backup/restore. The locale is stored
/// as a bare language code; `null` means "follow the system locale".
class SettingsService {
  SettingsService(this._dao);

  final SettingsDao _dao;

  static const _localeKey = 'locale';
  static const _userNameKey = 'userName';

  /// The persisted UI locale, or `null` when none is set (follow system).
  Future<Locale?> getLocale() async {
    final code = await _dao.getValue(_localeKey);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  /// Persists [locale]'s language code; `null` clears it (back to system).
  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await _dao.deleteKey(_localeKey);
    } else {
      await _dao.setValue(_localeKey, locale.languageCode);
    }
  }

  /// The persisted user display name, or `null`/empty when none is set — the
  /// signal `main()` and the app shell use to show the first-launch welcome.
  Future<String?> getUserName() async {
    final name = await _dao.getValue(_userNameKey);
    return (name == null || name.isEmpty) ? null : name;
  }

  /// Persists the user's display name (trimmed). An empty/blank name clears it.
  Future<void> setUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      await _dao.deleteKey(_userNameKey);
    } else {
      await _dao.setValue(_userNameKey, trimmed);
    }
  }
}
