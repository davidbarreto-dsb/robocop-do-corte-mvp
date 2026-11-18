import 'dart:convert';
import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

void main() {
  runApp(const RobocopApp());
}

const Color azulNeon = Color(0xFF00BFFF);
const Color fundoEscuro = Color(0xFF101820);
const Color dourado = Color(0xFFFFD700);

// =====================================================
// MODELO DO CLIENTE
// =====================================================

class Cliente {
  final String nome;
  final String telefone;
  final String email;

  const Cliente({
    required this.nome,
    required this.telefone,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'telefone': telefone,
    'email': email,
  };

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
    );
  }
}

// =====================================================
// AUTENTICAÇÃO E ARMAZENAMENTO LOCAL
// =====================================================

class AuthService {
  static const String _chaveClientes = 'clientes';
  static const String _chaveSessao = 'sessao_email';

  static Future<List<Map<String, dynamic>>> _lerClientes() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString(_chaveClientes);

    if (dados == null) return [];

    final lista = jsonDecode(dados) as List;
    return lista.cast<Map<String, dynamic>>();
  }

  static Future<Cliente?> recuperarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_chaveSessao);

    if (email == null) return null;

    final clientes = await _lerClientes();

    for (final dados in clientes) {
      if (dados['email'] == email) {
        return Cliente.fromJson(dados);
      }
    }

    await prefs.remove(_chaveSessao);
    return null;
  }

  static String _gerarHash(String senha, String salt) {
    return sha256.convert(utf8.encode('$salt:$senha')).toString();
  }

  static Future<String?> cadastrar({
    required String nome,
    required String telefone,
    required String email,
    required String senha,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final clientes = await _lerClientes();
    final emailNormalizado = email.trim().toLowerCase();

    final existe = clientes.any(
      (cliente) => cliente['email'] == emailNormalizado,
    );

    if (existe) {
      return 'Este e-mail já está cadastrado.';
    }

    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));

    final saltTexto = base64Encode(salt);

    clientes.add({
      'nome': nome.trim(),
      'telefone': telefone.trim(),
      'email': emailNormalizado,
      'salt': saltTexto,
      'senhaHash': _gerarHash(senha, saltTexto),
    });

    await prefs.setString(_chaveClientes, jsonEncode(clientes));
    await prefs.setString(_chaveSessao, emailNormalizado);

    return null;
  }

  static Future<Cliente?> entrar({
    required String email,
    required String senha,
  }) async {
    final emailNormalizado = email.trim().toLowerCase();
    final clientes = await _lerClientes();

    for (final dados in clientes) {
      if (dados['email'] == emailNormalizado) {
        final hash = _gerarHash(senha, dados['salt']);

        if (hash == dados['senhaHash']) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_chaveSessao, emailNormalizado);
          return Cliente.fromJson(dados);
        }

        return null;
      }
    }

    return null;
  }

  static Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveSessao);
  }
}

// =====================================================
// APLICATIVO E CONTROLE DA SESSÃO
// =====================================================

class RobocopApp extends StatefulWidget {
  const RobocopApp({super.key});

  @override
  State<RobocopApp> createState() => _RobocopAppState();
}

class _RobocopAppState extends State<RobocopApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Cliente? _clienteAtual;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarSessao();
  }

  Future<void> _carregarSessao() async {
    final cliente = await AuthService.recuperarSessao();

    if (!mounted) return;

    setState(() {
      _clienteAtual = cliente;
      _carregando = false;
    });
  }

  Future<void> _abrirCadastro() async {
    final cliente = await _navigatorKey.currentState!.push<Cliente>(
      MaterialPageRoute(builder: (_) => const TelaCadastro()),
    );

    if (cliente != null && mounted) {
      setState(() => _clienteAtual = cliente);
    }
  }

  Future<void> _abrirLogin() async {
    final cliente = await _navigatorKey.currentState!.push<Cliente>(
      MaterialPageRoute(builder: (_) => const TelaLogin()),
    );

    if (cliente != null && mounted) {
      setState(() => _clienteAtual = cliente);
    }
  }

  Future<void> _abrirAgendamento() async {
    if (_clienteAtual == null) {
      await _abrirLogin();
    }

    if (!mounted || _clienteAtual == null) return;

    _navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => TelaAgendamento(clienteNome: _clienteAtual!.nome),
      ),
    );
  }

  Future<void> _sair() async {
  await AuthService.sair();

  if (!mounted) return;

  setState(() {
    _clienteAtual = null;
  });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Robocop do Corte',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: fundoEscuro,
      ),
      home: _carregando
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator(color: azulNeon)),
            )
          : TelaInicial(
              cliente: _clienteAtual,
              onEntrar: _abrirLogin,
              onCadastrar: _abrirCadastro,
              onAgendar: _abrirAgendamento,
              onSair: _sair,
            ),
    );
  }
}

// =====================================================
// TELA INICIAL
// =====================================================

class TelaInicial extends StatelessWidget {
  final Cliente? cliente;
  final VoidCallback onEntrar;
  final VoidCallback onCadastrar;
  final VoidCallback onAgendar;
  final VoidCallback onSair;

  const TelaInicial({
    super.key,
    required this.cliente,
    required this.onEntrar,
    required this.onCadastrar,
    required this.onAgendar,
    required this.onSair,
  });

  @override
  Widget build(BuildContext context) {
    final autenticado = cliente != null;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF101820), Color(0xFF05090D)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield, size: 90, color: azulNeon),
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
                  const SizedBox(height: 35),

                  if (autenticado) ...[
                    Text(
                      'OLÁ, ${cliente!.nome.toUpperCase()}!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: azulNeon,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (!autenticado) ...[
                    _botaoPrincipal(
                      texto: 'ENTRAR',
                      cor: azulNeon,
                      aoPressionar: onEntrar,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: onCadastrar,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: azulNeon, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'CADASTRAR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: onAgendar,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text(
                        'AGENDAR HORÁRIO',
                        style: TextStyle(fontWeight: FontWeight.bold),
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

                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TelaServicos()),
                      );
                    },
                    icon: const Icon(Icons.content_cut),
                    label: const Text(
                      'VER SERVIÇOS',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(foregroundColor: dourado),
                  ),

                  if (autenticado) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: onSair,
                      icon: const Icon(Icons.logout),
                      label: const Text('SAIR DA CONTA'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                    ),
                  ],

                  const SizedBox(height: 45),
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

  Widget _botaoPrincipal({
    required String texto,
    required Color cor,
    required VoidCallback aoPressionar,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: aoPressionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

// =====================================================
// TELA DE LOGIN
// =====================================================

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _mostrarSenha = false;
  bool _processando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _processando = true);

    final cliente = await AuthService.entrar(
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;

    setState(() => _processando = false);

    if (cliente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha incorretos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context, cliente);
  }

  Future<void> _abrirCadastro() async {
    final cliente = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute(builder: (_) => const TelaCadastro()),
    );

    if (cliente != null && mounted) {
      Navigator.pop(context, cliente);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ENTRAR'),
        backgroundColor: const Color(0xFF080D12),
        iconTheme: const IconThemeData(color: azulNeon),
      ),
      body: _fundo(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_open, size: 65, color: azulNeon),
                const SizedBox(height: 18),
                const Text(
                  'ACESSE SUA CONTA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: azulNeon,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _campoTexto(
                  controller: _emailController,
                  rotulo: 'E-mail',
                  icone: Icons.email_outlined,
                  teclado: TextInputType.emailAddress,
                  validator: (valor) {
                    if (valor == null || !valor.contains('@')) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: _decoracao('Senha', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _mostrarSenha = !_mostrarSenha);
                      },
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                        color: azulNeon,
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Informe sua senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _processando ? null : _entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulNeon,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      _processando ? 'AGUARDE...' : 'ENTRAR',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: _abrirCadastro,
                  child: const Text(
                    'Não tem conta? Cadastre-se',
                    style: TextStyle(color: dourado),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// TELA DE CADASTRO
// =====================================================

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _mostrarSenha = false;
  bool _processando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _processando = true);

    final erro = await AuthService.cadastrar(
      nome: _nomeController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;

    setState(() => _processando = false);

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
      return;
    }

    final cliente = Cliente(
      nome: _nomeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
    );

    Navigator.pop(context, cliente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRO DE CLIENTE'),
        backgroundColor: const Color(0xFF080D12),
        iconTheme: const IconThemeData(color: azulNeon),
      ),
      body: _fundo(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add_alt_1, size: 65, color: azulNeon),
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
                const SizedBox(height: 25),
                _campoTexto(
                  controller: _nomeController,
                  rotulo: 'Nome completo',
                  icone: Icons.person_outline,
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu nome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _campoTexto(
                  controller: _telefoneController,
                  rotulo: 'Telefone / WhatsApp',
                  icone: Icons.phone_outlined,
                  teclado: TextInputType.phone,
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu telefone.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _campoTexto(
                  controller: _emailController,
                  rotulo: 'E-mail',
                  icone: Icons.email_outlined,
                  teclado: TextInputType.emailAddress,
                  validator: (valor) {
                    if (valor == null || !valor.contains('@')) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: _decoracao('Senha', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _mostrarSenha = !_mostrarSenha);
                      },
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                        color: azulNeon,
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _processando ? null : _cadastrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulNeon,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      _processando ? 'AGUARDE...' : 'CRIAR CONTA',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
    );
  }
}

// =====================================================
// TELA DE SERVIÇOS
// =====================================================

class TelaServicos extends StatelessWidget {
  const TelaServicos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOSSOS SERVIÇOS'),
        backgroundColor: const Color(0xFF080D12),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: azulNeon),
      ),
      body: _fundo(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.content_cut, size: 55, color: azulNeon),
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
              style: TextStyle(color: Colors.white70),
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
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
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
    );
  }
}

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
        side: const BorderSide(color: Color(0xFF087DAD)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icone, size: 38, color: azulNeon),
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
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
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

// =====================================================
// TELA DE AGENDAMENTO
// =====================================================

class TelaAgendamento extends StatefulWidget {
  final String clienteNome;

  const TelaAgendamento({super.key, required this.clienteNome});

  @override
  State<TelaAgendamento> createState() => _TelaAgendamentoState();
}

class _TelaAgendamentoState extends State<TelaAgendamento> {
  final _formKey = GlobalKey<FormState>();

  String? _servicoSelecionado;
  DateTime? _dataSelecionada;
  TimeOfDay? _horarioSelecionado;

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 90)),
      helpText: 'Selecione a data',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
    );

    if (data != null) {
      setState(() => _dataSelecionada = data);
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
      setState(() => _horarioSelecionado = horario);
    }
  }

  void _confirmarAgendamento() {
    if (!_formKey.currentState!.validate()) return;

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
      body: _fundo(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.calendar_month, size: 65, color: azulNeon),
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
                Text(
                  'Cliente: ${widget.clienteNome}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
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
                    prefixIcon: const Icon(Icons.content_cut, color: azulNeon),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: azulNeon),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: const Text('Escolha um serviço'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Corte Masculino',
                      child: Text('Corte Masculino'),
                    ),
                    DropdownMenuItem(value: 'Barba', child: Text('Barba')),
                    DropdownMenuItem(
                      value: 'Corte + Barba',
                      child: Text('Corte + Barba'),
                    ),
                  ],
                  onChanged: (valor) {
                    setState(() => _servicoSelecionado = valor);
                  },
                  validator: (valor) {
                    if (valor == null) return 'Selecione um serviço.';
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
                  icon: const Icon(Icons.calendar_today, color: azulNeon),
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
                  icon: const Icon(Icons.access_time, color: azulNeon),
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
                  child: const Text('VOLTAR', style: TextStyle(color: dourado)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// COMPONENTES VISUAIS REUTILIZÁVEIS
// =====================================================

BoxDecoration get _decoracaoFundo => const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF101820), Color(0xFF05090D)],
  ),
);

Widget _fundo({required Widget child}) {
  return Container(
    width: double.infinity,
    decoration: _decoracaoFundo,
    child: SafeArea(child: child),
  );
}

InputDecoration _decoracao(String rotulo, IconData icone) {
  return InputDecoration(
    labelText: rotulo,
    labelStyle: const TextStyle(color: Colors.white70),
    prefixIcon: Icon(icone, color: azulNeon),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: azulNeon),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: azulNeon, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

Widget _campoTexto({
  required TextEditingController controller,
  required String rotulo,
  required IconData icone,
  required String? Function(String?) validator,
  TextInputType teclado = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: teclado,
    style: const TextStyle(color: Colors.white),
    decoration: _decoracao(rotulo, icone),
    validator: validator,
  );
}
