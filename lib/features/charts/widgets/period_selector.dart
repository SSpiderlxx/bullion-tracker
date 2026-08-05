import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../core/theme/app_colors.dart';

class PeriodSelector extends HookWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(2);
    final periods = ['1W', '1M', '3M', '6M', '1Y', 'All'];

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(periods.length, (index) {
          final isSelected = selectedIndex.value == index;
          return GestureDetector(
            onTap: () => selectedIndex.value = index,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                periods[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : AppColors.darkTextSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
