import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';

class RecommendationSelectionBanner extends StatelessWidget {
  const RecommendationSelectionBanner({
    super.key,
    required this.selectedCount,
    required this.onClear,
  });

  final int selectedCount;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCount > 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: hasSelection ? ColorConstants.roseLight : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasSelection
              ? const Color(0xFFFFE4E6)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: hasSelection ? ColorConstants.rose : const Color(0xFFD1D5DB),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$selectedCount',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasSelection
                  ? '$selectedCount개 선택됨 · 최대 3개 선택 가능'
                  : '옷을 선택해주세요 · 최대 3개',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: hasSelection ? ColorConstants.rose : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          if (hasSelection)
            GestureDetector(
              onTap: onClear,
              child: const Text(
                '초기화',
                style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ),
        ],
      ),
    );
  }
}
