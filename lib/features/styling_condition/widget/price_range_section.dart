import 'package:flutter/material.dart';

class PriceRangeSection extends StatelessWidget {
  const PriceRangeSection({
    super.key,
    required this.selectedRange,
    required this.onRangeTap,
  });

  final String selectedRange;
  final ValueChanged<String> onRangeTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9EBF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '₩18,000',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              Spacer(),
              Text(
                '선택 범위',
                style: TextStyle(
                  color: Color(0xFFFF7A90),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                '₩150,000',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EE),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A90),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Row(
                children: [
                  _RangeThumb(),
                  Spacer(),
                  _RangeThumb(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _RangeTag(
                label: '~3만원',
                isSelected: selectedRange == '~3만원',
                onTap: () => onRangeTap('~3만원'),
              ),
              _RangeTag(
                label: '3~10만원',
                isSelected: selectedRange == '3~10만원',
                onTap: () => onRangeTap('3~10만원'),
              ),
              _RangeTag(
                label: '10~20만원',
                isSelected: selectedRange == '10~20만원',
                onTap: () => onRangeTap('10~20만원'),
              ),
              _RangeTag(
                label: '20만원+',
                isSelected: selectedRange == '20만원+',
                onTap: () => onRangeTap('20만원+'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RangeThumb extends StatelessWidget {
  const _RangeThumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFF7A90), width: 3),
      ),
    );
  }
}

class _RangeTag extends StatelessWidget {
  const _RangeTag({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF1F4) : const Color(0xFFF6F7FA),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7A90) : const Color(0xFFE9EBF2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFF617E) : const Color(0xFF6D7280),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
