
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const RobocopApp());
}

const Color azulNeon = Color(0xFF00BFFF);
const Color fundoEscuro = Color(0xFF101820);
const Color dourado = Color(0xFFFFD700);

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
        scaffoldBackgroundColor: fundoEscuro,
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
        backgroundColor: azulNeon,
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
                    color: azulNeon,
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
                      color: azulNeon,
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

                  // Botão Entrar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        mostrarMensagem(
                          context,
                          'Área de login em desenvolvimento.',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulNeon,
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

                  // Botão Cadastrar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        mostrarMensagem(
                          context,
                          'Cadastro em desenvolvimento.',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: azulNeon,
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

                  // Botão Ver Serviços
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaServicos(),
                        ),
                      );
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
                      foregroundColor: dourado,
                    ),
                  ),

                  const SizedBox(height: 50),
                  const Text(
                    'ROBOCOP DO CORTE © 2026',
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

// Tela de serviços da barbearia
class TelaServicos extends StatelessWidget {
  const TelaServicos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOSSOS SERVIÇOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF080D12),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: azulNeon),
      ),
      body: Container(
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
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(
                Icons.content_cut,
                size: 55,
                color: azulNeon,
              ),
              const SizedBox(height: 12),
              const Text(
                'ESTILO SOB MEDIDA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: azulNeon,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Confira os serviços da Robocop do Corte.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),

              const CartaoServico(
                icone: Icons.content_cut,
                titulo: 'Corte Masculino',
                descricao: 'Cuidado e estilo para o seu visual.',
              ),

              const CartaoServico(
                icone: Icons.face,
                titulo: 'Barba',
                descricao: 'Atenção aos detalhes e acabamento.',
              ),

              const CartaoServico(
                icone: Icons.auto_awesome,
                titulo: 'Corte + Barba',
                descricao: 'Um visual completo em um só atendimento.',
              ),

              const SizedBox(height: 20),

              const Text(
                'Consulte os valores e horários disponíveis '
                'diretamente com a barbearia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 24),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('VOLTAR AO INÍCIO'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: azulNeon,
                  side: const BorderSide(color: azulNeon),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Cartão reutilizável para apresentar cada serviço
class CartaoServico extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;

  const CartaoServico({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1B2833),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFF087DAD),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              icone,
              size: 38,
              color: azulNeon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    descricao,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
