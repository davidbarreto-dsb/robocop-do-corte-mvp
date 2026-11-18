
import 'package:flutter_test/flutter_test.dart';
import 'package:robocop_do_corte/main.dart';

void main() {
  testWidgets('Tela inicial do Robocop do Corte',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RobocopApp());

    expect(find.text('ROBOCOP'), findsOneWidget);
    expect(find.text('DO CORTE'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(find.text('CADASTRAR'), findsOneWidget);
  });
}
