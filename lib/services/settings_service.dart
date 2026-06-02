import 'dart:ui' show Locale;

import '../data/daos.dart';

/// App preferences persisted in the drift `settings` KV table. Currently just
/// the UI locale. Storage is language-independent (a bare language code);
/// `null` means "follow the system locale".
class SettingsService {
  SettingsService(this._dao);

  final SettingsDao _dao;

  static const _localeKey = 'locale';

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
}
