import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/view/recommendation_view.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_card.dart';

void main() {
  testWidgets('추천 화면 레이아웃 렌더링', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('나에게 맞는 추천 스타일'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('옷을 선택해주세요'), findsOneWidget);
  });

  testWidgets('상품 카드 목록 렌더링', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(RecommendationCard), findsWidgets);
  });

  testWidgets('선택 전 액션 버튼 비활성 상태', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('옷을 선택해주세요'), findsOneWidget);
  });

  testWidgets('카드 선택 시 선택 배너 업데이트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byType(RecommendationCard).first);
    await tester.pump();

    expect(find.text('1개 선택됨 · 최대 3개 선택 가능'), findsOneWidget);
    expect(find.text('선택한 옷 착용 이미지 생성하기'), findsOneWidget);
  });

  testWidgets('카드 복수 선택 시 액션 버튼 활성화', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byType(RecommendationCard).first);
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byType(RecommendationCard).at(1),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(RecommendationCard).at(1));
    await tester.pump();

    expect(find.text('선택한 옷 착용 이미지 생성하기'), findsOneWidget);
  });

  testWidgets('카드 선택 해제 시 배너 업데이트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byType(RecommendationCard).first);
    await tester.pump();
    await tester.tap(find.byType(RecommendationCard).first);
    await tester.pump();

    expect(find.text('옷을 선택해주세요 · 최대 3개'), findsOneWidget);
  });

  testWidgets('초기화 버튼으로 선택 해제', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byType(RecommendationCard).first);
    await tester.pump();
    await tester.tap(find.text('초기화'));
    await tester.pump();

    expect(find.text('옷을 선택해주세요 · 최대 3개'), findsOneWidget);
  });

  testWidgets('검색어로 상품 목록 필터링', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecommendationView(clothingType: ClothingType.top),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    final beforeCount = tester.widgetList(find.byType(RecommendationCard)).length;

    await tester.enterText(find.byType(TextField), 'H&M');
    await tester.pump();

    final afterCount = tester.widgetList(find.byType(RecommendationCard)).length;
    expect(afterCount, lessThan(beforeCount));
  });
}
