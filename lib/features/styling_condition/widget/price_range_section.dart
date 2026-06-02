import 'package:flutter/material.dart';

class PriceRangeSection extends StatelessWidget {
  const PriceRangeSection({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.minAllowedPrice,
    required this.maxAllowedPrice,
    required this.onChanged,
  });

  final int minPrice;
  final int maxPrice;
  final int minAllowedPrice;
  final int maxAllowedPrice;
  final ValueChanged<RangeValues> onChanged;

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
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _formatPrice(minPrice),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '선택 범위',
                  style: TextStyle(
                    color: Color(0xFFFF7A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatPrice(maxPrice),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFF7A90),
              inactiveTrackColor: const Color(0xFFE5E7EE),
              thumbColor: Colors.white,
              overlayColor: const Color(0x22FF7A90),
              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 11),
              trackHeight: 6,
            ),
            child: RangeSlider(
              values: RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
              min: minAllowedPrice.toDouble(),
              max: maxAllowedPrice.toDouble(),
              // Snap to 1000원 steps: (max - min) / 1000 구간.
              divisions: ((maxAllowedPrice - minAllowedPrice) / 1000).round(),
              labels: RangeLabels(_formatPrice(minPrice), _formatPrice(maxPrice)),
              onChanged: (values) => onChanged(
                RangeValues(
                  _roundToStep(values.start),
                  _roundToStep(values.end),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '최소 ${_formatPrice(minAllowedPrice)}',
                style: const TextStyle(
                  color: Color(0xFF6D7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '최대 ${_formatPrice(maxAllowedPrice)}',
                style: const TextStyle(
                  color: Color(0xFF6D7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Normalize a slider value to the nearest 1000원 step.
double _roundToStep(double value) => (value / 1000).round() * 1000;

String _formatPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final reverseIndex = digits.length - i;
    buffer.write(digits[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write(',');
    }
  }

  return '₩$buffer';
}
