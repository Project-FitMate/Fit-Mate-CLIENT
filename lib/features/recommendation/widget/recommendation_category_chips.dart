import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

/// Horizontal category filter chips for the recommendation list.
/// Shows "전체" plus the parts the user actually requested; tapping a chip
/// filters the list to that part (null = 전체).
class RecommendationCategoryChips extends StatelessWidget {
  const RecommendationCategoryChips({
    super.key,
    required this.parts,
    required this.selectedCategory,
    required this.onSelect,
  });

  final List<OutfitPart> parts;
  final OutfitPart? selectedCategory;
  final ValueChanged<OutfitPart?> onSelect;

  @override
  Widget build(BuildContext context) {
    // A single part has nothing to filter — hide the bar entirely.
    if (parts.length < 2) return const SizedBox.shrink();

    final categories = <OutfitPart?>[null, ...parts];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? ColorConstants.coral : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
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
