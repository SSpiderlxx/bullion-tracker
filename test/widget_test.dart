import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bullion_tracker/app.dart';

void main() {
  testWidgets('App should render without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BullionTrackerApp(),
      ),
    );
    
    // Verify the app title is present
    expect(find.text('Bullion Tracker'), findsOneWidget);
  });
}
