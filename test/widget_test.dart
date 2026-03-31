import 'package:flutter_test/flutter_test.dart';
import 'package:fit_mate_client/main.dart';

void main() {
  testWidgets('renders upload placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const FitMateApp());

    expect(find.text('Upload'), findsOneWidget);
    expect(find.text('Upload feature placeholder'), findsOneWidget);
  });
}
