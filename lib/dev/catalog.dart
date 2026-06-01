// Dev-only component catalog — renders every shared widget + chart so Phase 2
// can be reviewed at a glance. Not shipped UI (replaced by real screens).

import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../core/icons/lm_icons.dart';
import '../core/widgets/app_top_bar.dart';
import '../core/widgets/card.dart';
import '../core/widgets/eyebrow.dart';
import '../core/widgets/field.dart';
import '../core/widgets/lm_button.dart';
import '../core/widgets/lm_row.dart';
import '../core/widgets/lm_stepper.dart';
import '../core/widgets/lm_toast.dart';
import '../core/widgets/mood_picker.dart';
import '../core/widgets/period_chips.dart';
import '../core/widgets/photo.dart';
import '../core/widgets/pill.dart';
import '../core/widgets/scale10.dart';
import '../core/widgets/screen_body.dart';
import '../core/widgets/section_title.dart';
import '../core/widgets/segmented.dart';
import '../core/widgets/stat.dart';
import '../core/widgets/yes_no.dart';
import '../core/charts/sparkline.dart';
import '../core/charts/mini_bars.dart';
import '../core/charts/lm_bar_chart.dart';
import '../core/charts/ring.dart';
import '../core/charts/seg_ring.dart';
import '../core/charts/mood_gauge.dart';

class ComponentCatalog extends StatefulWidget {
  const ComponentCatalog({super.key});
  @override
  State<ComponentCatalog> createState() => _ComponentCatalogState();
}

class _ComponentCatalogState extends State<ComponentCatalog> {
  String _period = 'Днес';
  String _seg = 'Обяд';
  bool? _yn = true;
  int _scale = 7;
  int _mood = 8;
  int _steps = 9420;

  static const _series = <double>[3, 5, 4, 6, 5, 7, 8, 6, 9, 7];
  static const _dow = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'нд'];

  @override
  Widget build(BuildContext context) {
    return ScreenBody(
      children: [
        const _H('Бутони'),
        const LmButton('Запази', full: true, icon: LmIcons.check),
        const SizedBox(height: 8),
        Row(children: const [
          Expanded(child: LmButton('Откажи', variant: LmButtonVariant.ghost)),
          SizedBox(width: 10),
          Expanded(child: LmButton('Изтрий', variant: LmButtonVariant.danger, icon: LmIcons.trash)),
        ]),

        const _H('Карти'),
        Row(children: [
          const Expanded(child: LmCard(child: Text('Card', style: TextStyle(color: AppColors.text)))),
          const SizedBox(width: 10),
          Expanded(
            child: LmCard(
              highlighted: true,
              onTap: () => showLmToast(context, 'Картата е натисната'),
              child: const Text('Highlighted · tap', style: TextStyle(color: AppColors.text)),
            ),
          ),
        ]),

        const _H('Pill / Delta'),
        Wrap(spacing: 8, runSpacing: 8, children: const [
          Pill('нормално', color: AppColors.green, background: AppColors.greenSoft),
          Pill('High', color: AppColors.red),
          Pill('Планирано', color: AppColors.accent, background: AppColors.accentSoft),
          DeltaBadge(12),
          DeltaBadge(-8),
        ]),

        const _H('Stat'),
        Row(children: const [
          Expanded(child: Stat(label: 'Средно', value: '7.4', unit: 'ср.')),
          Expanded(child: Stat(label: 'Крачки', value: '9 420', color: AppColors.purple)),
          Expanded(child: Stat(label: 'Баланс', value: '+1 190', unit: '€', color: AppColors.green, sub: 'този месец')),
        ]),

        const _H('Row'),
        LmRow(
          icon: LmIcons.food, iconColor: AppColors.amber,
          title: 'Закуска', subtitle: 'Овесена каша · 420 kcal',
          tag: const Pill('420', color: AppColors.amber),
          trailing: const LmIcon(LmIcons.chevR, size: 16, color: AppColors.textFaint),
          onTap: () {},
        ),

        SectionTitle('Секция', action: const Text('виж всички →', style: TextStyle(color: AppColors.accent, fontSize: 12))),
        const Text('съдържание…', style: TextStyle(color: AppColors.textDim)),

        const _H('TopBar'),
        const AppTopBar(title: 'Здраве', subtitle: 'лична здравна история', showBack: true),

        const _H('Полета'),
        const Field(label: 'Име / описание', required: true, child: LmInput(hintText: 'напр. Пилешко с ориз')),
        const Field(label: 'Бележка', hint: 'optional', child: LmTextArea(hintText: 'как мина денят?')),

        const _H('Segmented'),
        Segmented(
          options: const ['Закуска', 'Обяд', 'Вечеря', 'Snack', 'Друго'],
          value: _seg, onChanged: (v) => setState(() => _seg = v),
        ),

        const _H('Да / Не'),
        YesNo(value: _yn, onChanged: (v) => setState(() => _yn = v)),

        const _H('Scale 1–10'),
        Scale10(value: _scale, onChanged: (v) => setState(() => _scale = v)),

        const _H('MoodPicker'),
        MoodPicker(value: _mood, onChanged: (v) => setState(() => _mood = v)),

        const _H('Stepper'),
        LmStepper(value: _steps, step: 100, min: 0, suffix: 'крачки', onChanged: (v) => setState(() => _steps = v)),

        const _H('PeriodChips'),
        PeriodChips(value: _period, onChanged: (v) => setState(() => _period = v)),

        const _H('Снимки'),
        const PhotoAdd(multi: true),
        const SizedBox(height: 10),
        Row(children: const [
          Expanded(child: PhotoTile(date: '31 май', hue: 40)),
          SizedBox(width: 8),
          Expanded(child: PhotoTile(date: '30 май', hue: 220)),
          SizedBox(width: 8),
          Expanded(child: PhotoTile(date: '29 май', hue: 150)),
        ]),

        const _H('Toast'),
        LmButton('Покажи toast', variant: LmButtonVariant.ghost,
            onTap: () => showLmToast(context, 'Записано успешно')),

        const _H('Графики'),
        const LmCard(child: Sparkline(data: _series)),
        const SizedBox(height: 10),
        const LmCard(child: MiniBars(data: _series, highlightIndex: 9)),
        const SizedBox(height: 10),
        const LmCard(child: LmBarChart(data: _series, labels: _dow, highlightLast: true)),
        const SizedBox(height: 10),
        Row(children: [
          const Ring(
            value: 7.4, max: 10, size: 96, color: AppColors.accent,
            center: Text('7.4', style: TextStyle(color: AppColors.text, fontFamily: 'IBM Plex Mono', fontWeight: FontWeight.w600, fontSize: 20)),
          ),
          const SizedBox(width: 18),
          const SegRing(
            segments: [
              SegRingSegment(640, AppColors.amber),
              SegRingSegment(420, AppColors.red),
              SegRingSegment(300, AppColors.pink),
              SegRingSegment(230, AppColors.purple),
            ],
            center: Text('1 590', style: TextStyle(color: AppColors.text, fontFamily: 'IBM Plex Mono', fontWeight: FontWeight.w600)),
          ),
        ]),
        const _H('MoodGauge'),
        MoodGauge(value: _mood),
        const SizedBox(height: 12),
      ],
    );
  }
}

/// Section header used throughout the catalog.
class _H extends StatelessWidget {
  const _H(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 22, 0, 10),
        child: Eyebrow(text),
      );
}
