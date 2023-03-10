import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kwetter/main.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('check splash screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text("v1.0"), findsOneWidget);
    });
  });
}