// Dev-only panel to load/clear sample data (third tab of DevHome).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../core/theme/typography.dart';
import '../core/widgets/eyebrow.dart';
import '../core/widgets/lm_button.dart';
import '../core/widgets/lm_toast.dart';
import '../core/widgets/screen_body.dart';
import 'seed.dart';

class SeedPanel extends ConsumerWidget {
  const SeedPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    return ScreenBody(
      children: [
        const Eyebrow('Примерни данни'),
        const SizedBox(height: 10),
        const Text(
          'Зарежда ~30 дни реалистични данни във всички модули. Само за '
          'разработка — не се включва в release.',
          style: AppText.bodyDim,
        ),
        const SizedBox(height: 16),
        LmButton(
          'Зареди примерни данни',
          full: true,
          onTap: () async {
            await seedDatabase(db);
            if (context.mounted) {
              showLmToast(context, 'Примерните данни са заредени');
            }
          },
        ),
        const SizedBox(height: 10),
        LmButton(
          'Изчисти данните',
          variant: LmButtonVariant.danger,
          full: true,
          onTap: () async {
            await clearAll(db);
            if (context.mounted) showLmToast(context, 'Данните са изчистени');
          },
        ),
      ],
    );
  }
}
