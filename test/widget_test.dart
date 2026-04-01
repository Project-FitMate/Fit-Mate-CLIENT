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
}
