import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class ResultCategoryChips extends StatelessWidget {
  const ResultCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onSelect,
  });

  final ClothingType? selectedCategory;
  final ValueChanged<ClothingType?> onSelect;

  @override
  Widget build(BuildContext context) {
    final categories = [null, ...ClothingType.values];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          final label = category?.label ?? '전체';
          return GestureDetector(
            onTap: () => onSelect(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? ColorConstants.coral : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
