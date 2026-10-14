import 'package:flutter_test/flutter_test.dart';
import 'package:studymate/main.dart';

void main() {
  testWidgets('StudyMate app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyMateApp());
    expect(find.text('Home'), findsOneWidget);
  });
}
