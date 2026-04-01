import 'package:flutter_test/flutter_test.dart';
import 'package:fit_mate_client/features/styling_condition/view/styling_condition_view.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('renders styling condition layout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: StylingConditionView(),
      ),
    );

    expect(find.text('착용 조건 설정'), findsOneWidget);
    expect(find.text('사진 업로드 완료'), findsOneWidget);
    expect(find.text('제품 검색'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('스타일 추천받기'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('스타일 추천받기'), findsOneWidget);
  });

  testWidgets('updates selection states', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: StylingConditionView(),
      ),
    );

    await tester.tap(find.text('상의'));
    await tester.pump();
    expect(find.text('상의'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('가격 낮은순'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('가격 낮은순'));
    await tester.pump();
    expect(find.text('가격 낮은순'), findsOneWidget);

    await tester.tap(find.text('20만원+'));
    await tester.pump();
    expect(find.text('20만원+'), findsOneWidget);

    await tester.tap(find.text('초기화'));
    await tester.pump();
    expect(find.text('AI 추천순'), findsWidgets);
  });
}
