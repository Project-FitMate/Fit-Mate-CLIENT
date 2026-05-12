import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_mate_client/features/styling_condition/view/styling_condition_view.dart';
import 'package:fit_mate_client/features/upload/model/upload_photo.dart';

// Skipped after integration rewrite: StylingConditionView now requires
// an UploadPhoto and pushes RecommendationView with backend calls.
// TODO: rework with a fake photo + mocked repository.
void main() {
  testWidgets('renders styling condition layout', (WidgetTester tester) async {
    final photo = UploadPhoto(file: File('/tmp/x'), userImageName: 'x');
    await tester.pumpWidget(MaterialApp(home: StylingConditionView(photo: photo)));
    expect(find.text('착용 조건 설정'), findsOneWidget);
  }, skip: 'pending integration rework');
}
