import 'package:flutter_test/flutter_test.dart';
import 'package:save_n_serve/main.dart';

void main() {
  testWidgets('App smoke test — launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
  });
}
