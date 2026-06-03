import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Ergonomic access to the generated localizations: `context.l10n.actionSave`.
/// Non-null because `l10n.yaml` sets `nullable-getter: false` and the delegates
/// are installed on the root [MaterialApp].
extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
