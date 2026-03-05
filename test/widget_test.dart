import 'package:flutter_test/flutter_test.dart';

import 'package:nalargizi/app/app.dart';

void main() {
  testWidgets('App shows splash page', (WidgetTester tester) async {
    await tester.pumpWidget(const NalarGiziApp());

    expect(find.text('NalarGizi'), findsOneWidget);
  });
}
