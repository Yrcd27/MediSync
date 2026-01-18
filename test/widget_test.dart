import 'package:flutter_test/flutter_test.dart';
import 'package:medisync_app/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Allow animations to start
    await tester.pump();

    // Skip ahead through animations without waiting for them to settle
    // This prevents timeout from infinite repeating animations
    await tester.pump(const Duration(seconds: 1));

    // Verify splash screen appears with app name
    expect(find.text('MediSync'), findsOneWidget);
  });
}
