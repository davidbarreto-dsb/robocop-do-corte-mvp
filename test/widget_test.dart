
import 'package:flutter_test/flutter_test.dart';
import 'package:robocop_do_corte/main.dart';

void main() {
  testWidgets('Exibe a tela inicial', (tester) async {
    await tester.pumpWidget(const RobocopApp());

    expect(find.text('ROBOCOP'), findsOneWidget);
    expect(find.text('DO CORTE'), findsOneWidget);
    expect(find.text('CADASTRAR'), findsOneWidget);
  });

  testWidgets('Abre a tela de cadastro', (tester) async {
    await tester.pumpWidget(const RobocopApp());

    await tester.tap(find.text('CADASTRAR'));
    await tester.pumpAndSettle();

    expect(find.text('CADASTRO DE CLIENTE'), findsOneWidget);
    expect(find.text('CRIE SUA CONTA'), findsOneWidget);
    expect(find.text('Nome completo'), findsOneWidget);
  });
}
