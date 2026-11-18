
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robocop_do_corte/main.dart';
import 'package:material_ui/material_ui.dart';

Future<void> abrirApp(WidgetTester tester) async {
  await tester.pumpWidget(const RobocopApp());
  await tester.pumpAndSettle();
}

Future<void> cadastrarCliente(WidgetTester tester) async {
  await abrirApp(tester);

  await tester.tap(find.text('CADASTRAR'));
  await tester.pumpAndSettle();

  final campos = find.byType(TextFormField);

  await tester.ensureVisible(campos.at(0));
  await tester.enterText(campos.at(0), 'Cliente Teste');

  await tester.ensureVisible(campos.at(1));
  await tester.enterText(campos.at(1), '71999999999');

  await tester.ensureVisible(campos.at(2));
  await tester.enterText(campos.at(2), 'teste@email.com');

  await tester.ensureVisible(campos.at(3));
  await tester.enterText(campos.at(3), '123456');

  await tester.ensureVisible(find.text('CRIAR CONTA'));
  await tester.tap(find.text('CRIAR CONTA'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Exibe a tela inicial', (tester) async {
    await abrirApp(tester);

    expect(find.text('ROBOCOP'), findsOneWidget);
    expect(find.text('DO CORTE'), findsOneWidget);
    expect(find.text('CADASTRAR'), findsOneWidget);
  });

  testWidgets('Abre a tela de cadastro', (tester) async {
    await abrirApp(tester);

    await tester.tap(find.text('CADASTRAR'));
    await tester.pumpAndSettle();

    expect(find.text('CADASTRO DE CLIENTE'), findsOneWidget);
    expect(find.text('CRIE SUA CONTA'), findsOneWidget);
    expect(find.text('Nome completo'), findsOneWidget);
  });

  testWidgets('Visitante é direcionado ao login ao tentar agendar',
      (tester) async {
    await abrirApp(tester);

    await tester.tap(find.text('AGENDAR HORÁRIO'));
    await tester.pumpAndSettle();

    expect(find.text('ACESSE SUA CONTA'), findsOneWidget);
    expect(find.text('ENTRAR'), findsWidgets);
  });

  testWidgets('Cliente cadastrado consegue acessar o agendamento',
      (tester) async {
    await cadastrarCliente(tester);

    expect(find.text('OLÁ, CLIENTE TESTE!'), findsOneWidget);

    await tester.tap(find.text('AGENDAR HORÁRIO'));
    await tester.pumpAndSettle();

    expect(find.text('RESERVE SEU HORÁRIO'), findsOneWidget);
    expect(find.text('Cliente: Cliente Teste'), findsOneWidget);
  });

  testWidgets('Exibe as opções de serviços no agendamento', (tester) async {
    await cadastrarCliente(tester);

    await tester.tap(find.text('AGENDAR HORÁRIO'));
    await tester.pumpAndSettle();

    final campoServico = find.text('Escolha um serviço');

    await tester.ensureVisible(campoServico);
    await tester.tap(campoServico);
    await tester.pumpAndSettle();

    expect(find.text('Corte Masculino'), findsOneWidget);
    expect(find.text('Barba'), findsOneWidget);
    expect(find.text('Corte + Barba'), findsOneWidget);
  });

  testWidgets('Valida agendamento sem preenchimento', (tester) async {
    await cadastrarCliente(tester);

    await tester.tap(find.text('AGENDAR HORÁRIO'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('CONFIRMAR AGENDAMENTO'));
    await tester.tap(find.text('CONFIRMAR AGENDAMENTO'));
    await tester.pumpAndSettle();

    expect(find.text('Selecione um serviço.'), findsOneWidget);
  });
}
