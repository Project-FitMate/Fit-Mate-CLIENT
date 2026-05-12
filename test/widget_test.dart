import 'package:flutter_test/flutter_test.dart';
import 'package:fit_mate_client/main.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_card.dart';

void main() {
  testWidgets('renders recommendation screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FitMateApp());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('나에게 맞는 추천 스타일'), findsOneWidget);
    expect(find.text('전체'), findsOneWidget);
    expect(find.text('상의'), findsWidgets);
    expect(find.text('하의'), findsWidgets);
    expect(find.text('신발'), findsWidgets);
    expect(find.text('옷을 선택해주세요'), findsOneWidget);
  });

  testWidgets('selects product on recommendation screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FitMateApp());
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byType(RecommendationCard).first);
    await tester.pump();

    expect(find.text('선택한 옷 착용 이미지 생성하기'), findsOneWidget);
  });
}
