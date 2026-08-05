import 'package:flutter/material.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MetalTypeSelector extends StatelessWidget {
  final MetalType selectedType;
  final ValueChanged<MetalType> onChanged;

  const MetalTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: MetalType.values.map((type) {
          final isSelected = selectedType == type;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? type.displayColor.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? type.displayColor : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    type.displayName,
                    style: TextStyle(
                      color: isSelected ? type.displayColor : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
