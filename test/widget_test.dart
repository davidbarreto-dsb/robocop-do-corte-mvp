import 'package:flutter/material.dart';
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

  testWidgets('Abre a tela de agendamento', (tester) async {
    await tester.pumpWidget(const RobocopApp());

    await tester.tap(find.text('AGENDAR HORÁRIO'));
    await tester.pumpAndSettle();

    expect(find.text('AGENDAR HORÁRIO'), findsOneWidget);
    expect(find.text('RESERVE SEU HORÁRIO'), findsOneWidget);
  });

  testWidgets('Exibe as opções de serviços no agendamento', (tester) async {
    await tester.pumpWidget(const RobocopApp());

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
    await tester.pumpWidget(const RobocopApp());

    await tester.tap(find.text('AGENDAR HORÁRIO'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('CONFIRMAR AGENDAMENTO'));
    await tester.tap(find.text('CONFIRMAR AGENDAMENTO'));
    await tester.pumpAndSettle();

    expect(find.text('Selecione um serviço.'), findsOneWidget);
  });
}
