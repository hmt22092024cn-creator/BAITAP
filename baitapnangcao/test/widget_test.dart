import 'package:flutter_test/flutter_test.dart';
import 'package:baitapnangcao/main.dart';

void main() {
  testWidgets('App renders main screens smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that NÂNG CAO 01 title is displayed on screen
    expect(find.text('NÂNG CAO 01'), findsOneWidget);
  });
}
