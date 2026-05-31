// Dev-only design-system gallery — a scratch surface to eyeball Phase 1
// (fonts/Cyrillic, color tokens, the mood ramp, the icon set). This is the
// temporary app home until the router lands in Phase 5; not shipped UI.

import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';
import '../core/theme/typography.dart';
import '../core/theme/mood_color.dart';
import '../core/icons/lm_icons.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: const [
            Text('LifeMaxxing · дизайн система', style: AppText.greeting),
            SizedBox(height: 18),
            _FontsSection(),
            SizedBox(height: 24),
            _Eyebrow('Цветове'),
            _ColorsSection(),
            SizedBox(height: 24),
            _Eyebrow('Настроение 1–10'),
            _MoodSection(),
            SizedBox(height: 24),
            _Eyebrow('Икони'),
            _IconsSection(),
          ],
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text.toUpperCase(), style: AppText.eyebrow),
      );
}

class _FontsSection extends StatelessWidget {
  const _FontsSection();
  @override
  Widget build(BuildContext context) {
    const sample = 'Добър вечер, Мартин 0123';
    Widget row(String label, FontWeight w, {bool mono = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: 92,
                child: Text(label, style: AppText.monoFaint),
              ),
              Expanded(
                child: Text(
                  sample,
                  style: TextStyle(
                    fontFamily: mono ? AppText.mono : AppText.sans,
                    fontWeight: w,
                    fontSize: 17,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('IBM Plex Sans (кирилица)'),
        row('Regular 400', FontWeight.w400),
        row('Medium 500', FontWeight.w500),
        row('SemiBold 600', FontWeight.w600),
        row('Bold 700', FontWeight.w700),
        const SizedBox(height: 12),
        const _Eyebrow('IBM Plex Mono'),
        row('Regular 400', FontWeight.w400, mono: true),
        row('Medium 500', FontWeight.w500, mono: true),
        row('SemiBold 600', FontWeight.w600, mono: true),
      ],
    );
  }
}

class _ColorsSection extends StatelessWidget {
  const _ColorsSection();
  @override
  Widget build(BuildContext context) {
    const swatches = <(String, Color)>[
      ('bg', AppColors.bg),
      ('bg2', AppColors.bg2),
      ('card', AppColors.card),
      ('cardHi', AppColors.cardHi),
      ('text', AppColors.text),
      ('textDim', AppColors.textDim),
      ('textFaint', AppColors.textFaint),
      ('accent', AppColors.accent),
      ('green', AppColors.green),
      ('red', AppColors.red),
      ('amber', AppColors.amber),
      ('purple', AppColors.purple),
      ('pink', AppColors.pink),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final (name, c) in swatches)
          Column(
            children: [
              Container(
                width: 54,
                height: 38,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
              ),
              const SizedBox(height: 4),
              Text(name, style: AppText.monoFaint),
            ],
          ),
      ],
    );
  }
}

class _MoodSection extends StatelessWidget {
  const _MoodSection();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var v = 1; v <= 10; v++)
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: moodColor(v),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$v',
              style: const TextStyle(
                fontFamily: AppText.mono,
                fontWeight: FontWeight.w600,
                color: AppColors.bg,
              ),
            ),
          ),
      ],
    );
  }
}

class _IconsSection extends StatelessWidget {
  const _IconsSection();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final i in LmIcons.values)
          SizedBox(
            width: 64,
            child: Column(
              children: [
                LmIcon(i, size: 26, color: AppColors.text),
                const SizedBox(height: 6),
                Text(
                  i.name,
                  style: AppText.monoFaint,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
