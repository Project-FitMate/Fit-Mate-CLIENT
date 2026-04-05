import 'package:flutter_test/flutter_test.dart';
import 'package:fit_mate_client/main.dart';

void main() {
  testWidgets('renders upload screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FitMateApp());

    expect(find.text('핏메이트'), findsOneWidget);
    expect(find.text('카메라 촬영'), findsOneWidget);
    expect(find.text('내 사진 업로드'), findsOneWidget);
    expect(find.text('사진 분석하기'), findsOneWidget);
  });

  testWidgets('navigates to styling condition screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FitMateApp());

    await tester.tap(find.text('카메라 촬영'));
    await tester.pump();

    await tester.ensureVisible(find.text('사진 분석하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('사진 분석하기'));
    await tester.pumpAndSettle();

    expect(find.text('착용 조건 설정'), findsOneWidget);
    expect(find.text('제품 검색'), findsOneWidget);
  });
}
