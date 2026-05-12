import 'dart:typed_data';

import 'package:flutter/material.dart';

class ResultPreviewCard extends StatelessWidget {
  const ResultPreviewCard({
    super.key,
    required this.generatedImage,
    required this.onRegenerate,
  });

  final Uint8List? generatedImage;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 256,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3E8FF), Color(0xFFD1D5FF)],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Center(
            child: generatedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.memory(
                      generatedImage!,
                      fit: BoxFit.contain,
                      height: 240,
                    ),
                  )
                : const Icon(
                    Icons.person_outline_rounded,
                    size: 80,
                    color: Color(0xFFBDBDBD),
                  ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: Color(0xFFFF7E5F)),
                  SizedBox(width: 4),
                  Text(
                    'AI 생성 이미지',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
