import 'package:flutter_test/flutter_test.dart';
import 'package:foodiexpress/main.dart';

void main() {
  testWidgets('La app carga y muestra el título', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodiExpressApp());

    expect(find.text('FoodiExpress'), findsOneWidget);
  });
}
