import 'package:flutter/material.dart';

class RecommendationActionButton extends StatelessWidget {
  const RecommendationActionButton({
    super.key,
    required this.hasSelection,
    required this.onPressed,
  });

  final bool hasSelection;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isActive = hasSelection;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      color: Colors.white,
      child: GestureDetector(
        onTap: isActive ? onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 60,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isActive ? null : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF7E5F).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                isActive ? '선택한 옷 착용 이미지 생성하기' : '옷을 선택해주세요',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
