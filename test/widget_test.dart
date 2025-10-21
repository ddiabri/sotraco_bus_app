import 'package:flutter_test/flutter_test.dart';
import 'package:sotraco_bus_app/main.dart';

void main() {
  testWidgets('App loads with SOTRACO title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SotracoBusApp());

    // Verify that SOTRACO text is displayed
    expect(find.text('SOTRACO'), findsOneWidget);
    expect(find.text('Itinéraires des bus'), findsOneWidget);
  });
}
