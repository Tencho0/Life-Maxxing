// Income-vs-expense per-day bars (design "Приходи срещу разходи"). Two series
// stacked per day — income (green) above, expense (red) below — each scaled to
// its own max so both stay visible despite different magnitudes.

import 'package:flutter/widgets.dart';
import '../theme/tokens.dart';

class IncomeExpenseBars extends StatelessWidget {
  const IncomeExpenseBars({
    super.key,
    required this.income,
    required this.expense,
    this.height = 96,
  });

  /// Per-day series (aligned, same length).
  final List<double> income;
  final List<double> expense;
  final double height;

  @override
  Widget build(BuildContext context) {
    final n = income.length;
    final maxInc = income.fold<double>(0, (m, v) => v > m ? v : m);
    final maxExp = expense.fold<double>(0, (m, v) => v > m ? v : m);
    final half = (height - 4) / 2;

    double h(double v, double max) => max <= 0 ? 0 : (v / max) * half;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < n; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _bar(h(income[i], maxInc), AppColors.green),
                    const SizedBox(height: 2),
                    _bar(h(expense[i], maxExp), AppColors.red),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bar(double h, Color color) => Container(
        height: h < 0 ? 0 : h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}
