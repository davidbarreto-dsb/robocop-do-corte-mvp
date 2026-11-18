
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const RobocopApp());
}

class RobocopApp extends StatelessWidget {
  const RobocopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robocop do Corte',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  void mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: const Color(0xFF087DAD),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF101820),
              Color(0xFF05090D),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shield,
                    size: 90,
                    color: Color(0xFF00BFFF),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'ROBOCOP',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),

                  const Text(
                    'DO CORTE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 7,
                      color: Color(0xFF00BFFF),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'TECNOLOGIA E ESTILO EM UM SÓ LUGAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 2,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 55),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        mostrarMensagem(context, 'Área de login em desenvolvimento.');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFFF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        mostrarMensagem(context, 'Cadastro em desenvolvimento.');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF00BFFF),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextButton.icon(
                    onPressed: () {
                      mostrarMensagem(context, 'Lista de serviços em desenvolvimento.');
                    },
                    icon: const Icon(Icons.content_cut),
                    label: const Text(
                      'VER SERVIÇOS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFFD700),
                    ),
                  ),

                  const SizedBox(height: 50),

                  const Text(
                    'ROBocop DO CORTE © 2026',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white38,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
