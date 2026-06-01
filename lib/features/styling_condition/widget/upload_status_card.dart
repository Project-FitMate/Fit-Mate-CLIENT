import 'dart:typed_data';

import 'package:flutter/material.dart';

class UploadStatusCard extends StatelessWidget {
  const UploadStatusCard({super.key, this.photoBytes});

  final Uint8List? photoBytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9EBF2)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF4E6D1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF7A90), width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: photoBytes != null
                ? Image.memory(photoBytes!, fit: BoxFit.cover)
                : const Center(
                    child: Text('🧍', style: TextStyle(fontSize: 28)),
                  ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '사진 업로드 완료',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF21242C),
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFFFF617E),
                      size: 18,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '피부톤 · 체형 분석 준비됨\nAI가 자동으로 체형을 인식합니다',
                  style: TextStyle(
                    color: Color(0xFF717686),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '사진 변경',
                  style: TextStyle(
                    color: Color(0xFFFF617E),
                    fontWeight: FontWeight.w700,
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
