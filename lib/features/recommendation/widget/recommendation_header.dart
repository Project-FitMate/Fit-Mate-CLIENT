import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';

class RecommendationHeader extends StatelessWidget {
  const RecommendationHeader({
    super.key,
    required this.categories,
    required this.productCount,
    this.uploadedImage,
  });

  final List<String> categories;
  final int productCount;
  final File? uploadedImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: ColorConstants.coral,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE6D5BC),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: uploadedImage != null
                ? Image.file(uploadedImage!, fit: BoxFit.cover)
                : const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFFA08060),
                    size: 26,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '나에게 맞는 추천 스타일',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${categories.join(' · ')} · AI 추천순 · $productCount개',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
