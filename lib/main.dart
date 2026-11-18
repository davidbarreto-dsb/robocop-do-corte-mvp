
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaCadastro(),
                         ),
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

                  // Botão Agendar Horário
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaAgendamento(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: const Text(
                        'AGENDAR HORÁRIO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dourado,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

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

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  bool _mostrarSenha = false;

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro validado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRO DE CLIENTE'),
        backgroundColor: const Color(0xFF080D12),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: azulNeon),
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 65,
                    color: azulNeon,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'CRIE SUA CONTA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: azulNeon,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Preencha seus dados para começar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  _campo(
                    rotulo: 'Nome completo',
                    icone: Icons.person_outline,
                    mensagem: 'Informe seu nome.',
                  ),

                  const SizedBox(height: 18),

                  _campo(
                    rotulo: 'Telefone / WhatsApp',
                    icone: Icons.phone_outlined,
                    mensagem: 'Informe seu telefone.',
                    teclado: TextInputType.phone,
                  ),

                  const SizedBox(height: 18),

                  _campo(
                    rotulo: 'E-mail',
                    icone: Icons.email_outlined,
                    mensagem: 'Informe um e-mail válido.',
                    teclado: TextInputType.emailAddress,
                    email: true,
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    obscureText: !_mostrarSenha,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: azulNeon,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                        icon: Icon(
                          _mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: azulNeon,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: azulNeon,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: azulNeon,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _cadastrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulNeon,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CRIAR CONTA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'VOLTAR AO INÍCIO',
                      style: TextStyle(color: dourado),
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

  Widget _campo({
    required String rotulo,
    required IconData icone,
    required String mensagem,
    TextInputType teclado = TextInputType.text,
    bool email = false,
  }) {
    return TextFormField(
      keyboardType: teclado,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: rotulo,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icone, color: azulNeon),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: azulNeon),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: azulNeon,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return mensagem;
        }

        if (email && !valor.contains('@')) {
          return 'Digite um e-mail válido.';
        }

        return null;
      },
    );
  }
}

class TelaAgendamento extends StatefulWidget {
  const TelaAgendamento({super.key});

  @override
  State<TelaAgendamento> createState() => _TelaAgendamentoState();
}

class _TelaAgendamentoState extends State<TelaAgendamento> {
  final _formKey = GlobalKey<FormState>();

  String? _servicoSelecionado;
  DateTime? _dataSelecionada;
  TimeOfDay? _horarioSelecionado;

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ),
      helpText: 'Selecione a data',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Selecione o horário',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
    );

    if (horario != null) {
      setState(() {
        _horarioSelecionado = horario;
      });
    }
  }

  void _confirmarAgendamento() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dataSelecionada == null || _horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a data e o horário.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Agendamento preenchido com sucesso! '
          'A confirmação depende da barbearia.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGENDAR HORÁRIO'),
        backgroundColor: const Color(0xFF080D12),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: azulNeon),
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 65,
                    color: azulNeon,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'RESERVE SEU HORÁRIO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: azulNeon,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Escolha o serviço, a data e o horário desejados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Selecione o serviço',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue: _servicoSelecionado,
                    dropdownColor: const Color(0xFF1B2833),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.content_cut,
                        color: azulNeon,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: azulNeon),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    hint: const Text(
                      'Escolha um serviço',
                      style: TextStyle(color: Colors.white70),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Corte Masculino',
                        child: Text('Corte Masculino'),
                      ),
                      DropdownMenuItem(
                        value: 'Barba',
                        child: Text('Barba'),
                      ),
                      DropdownMenuItem(
                        value: 'Corte + Barba',
                        child: Text('Corte + Barba'),
                      ),
                    ],
                    onChanged: (valor) {
                      setState(() {
                        _servicoSelecionado = valor;
                      });
                    },
                    validator: (valor) {
                      if (valor == null) {
                        return 'Selecione um serviço.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Escolha a data',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  OutlinedButton.icon(
                    onPressed: _selecionarData,
                    icon: const Icon(
                      Icons.calendar_today,
                      color: azulNeon,
                    ),
                    label: Text(
                      _dataSelecionada == null
                          ? 'SELECIONAR DATA'
                          : '${_dataSelecionada!.day.toString().padLeft(2, '0')}/'
                            '${_dataSelecionada!.month.toString().padLeft(2, '0')}/'
                            '${_dataSelecionada!.year}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: azulNeon),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Escolha o horário',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  OutlinedButton.icon(
                    onPressed: _selecionarHorario,
                    icon: const Icon(
                      Icons.access_time,
                      color: azulNeon,
                    ),
                    label: Text(
                      _horarioSelecionado == null
                          ? 'SELECIONAR HORÁRIO'
                          : _horarioSelecionado!.format(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: azulNeon),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _confirmarAgendamento,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'CONFIRMAR AGENDAMENTO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulNeon,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'VOLTAR',
                      style: TextStyle(color: dourado),
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
