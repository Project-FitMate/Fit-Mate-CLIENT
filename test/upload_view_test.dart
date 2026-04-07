import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_mate_client/features/upload/view/upload_view.dart';

void main() {
  testWidgets('renders upload screen layout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UploadView()),
    );

    expect(find.text('핏메이트'), findsOneWidget);
    expect(find.text('안녕하세요'), findsOneWidget);
    expect(find.text('카메라 촬영'), findsOneWidget);
    expect(find.text('내 사진 업로드'), findsOneWidget);
    expect(find.text('사진 분석하기'), findsOneWidget);
  });

  testWidgets('action button is disabled before source selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UploadView()),
    );

    final buttonFinder = find.widgetWithText(ElevatedButton, '사진 분석하기');
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.onPressed, isNull);
  });

  testWidgets('selecting camera enables action button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UploadView()),
    );

    await tester.tap(find.text('카메라 촬영'));
    await tester.pump();

    expect(find.text('사진 업로드 완료'), findsOneWidget);

    final buttonFinder = find.widgetWithText(ElevatedButton, '사진 분석하기');
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.onPressed, isNotNull);
  });

  testWidgets('selecting gallery enables action button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UploadView()),
    );

    await tester.tap(find.text('내 사진 업로드'));
    await tester.pump();

    expect(find.text('사진 업로드 완료'), findsOneWidget);

    final buttonFinder = find.widgetWithText(ElevatedButton, '사진 분석하기');
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.onPressed, isNotNull);
  });

  testWidgets('switching source keeps button enabled', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UploadView()),
    );

    await tester.tap(find.text('카메라 촬영'));
    await tester.pump();

    await tester.tap(find.text('내 사진 업로드'));
    await tester.pump();

    expect(find.text('사진 업로드 완료'), findsOneWidget);

    final buttonFinder = find.widgetWithText(ElevatedButton, '사진 분석하기');
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.onPressed, isNotNull);
  });

  testWidgets('navigates to styling condition after camera selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UploadView()),
    );

    await tester.tap(find.text('카메라 촬영'));
    await tester.pump();

    await tester.ensureVisible(find.text('사진 분석하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('사진 분석하기'));
    await tester.pumpAndSettle();

    expect(find.text('착용 조건 설정'), findsOneWidget);
  });

  testWidgets('navigates to styling condition after gallery selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UploadView()),
    );

    await tester.tap(find.text('내 사진 업로드'));
    await tester.pump();

    await tester.ensureVisible(find.text('사진 분석하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('사진 분석하기'));
    await tester.pumpAndSettle();

    expect(find.text('착용 조건 설정'), findsOneWidget);
  });
}
