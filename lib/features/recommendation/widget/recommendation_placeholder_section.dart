import 'package:flutter/material.dart';

/// 추천 기능이 아직 구현되지 않은 영역에 임시로 표시하는 플레이스홀더 위젯
///
/// 실제 UI가 완성되면 이 위젯을 교체합니다.
class RecommendationPlaceholderSection extends StatelessWidget {
  const RecommendationPlaceholderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Recommendation feature placeholder'),
      ),
    );
  }
}
