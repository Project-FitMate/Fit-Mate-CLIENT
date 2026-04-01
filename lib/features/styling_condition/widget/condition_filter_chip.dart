import 'package:flutter/material.dart';

class ConditionFilterChip extends StatelessWidget {
  const ConditionFilterChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
  });

  final String label;
  final String? icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF1F4) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF7A90) : const Color(0xFFE9EBF2),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon!, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF617E) : const Color(0xFF50535F),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
