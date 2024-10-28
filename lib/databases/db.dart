import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> conectarBancoDeDados() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'sysmedicalapp.mysql.dbaas.com.br',
    port: 3306, // Porta padrão do MySQL
    user: 'sysmedicalapp',
    db: 'sysmedicalapp',
    password: 'SysMedical123!',
  ));

  return conn;
}

Future<void> verificarOuCriarTabela() async {
  // Configurações de conexão
  var conn = await conectarBancoDeDados();

  try {
    // Verifique se a tabela já existe
    var resultado = await conn.query("SHOW TABLES LIKE 'usuarios';");

    if (resultado.isEmpty) {
      // Crie a tabela se não existir
      await conn.query('''
        CREATE TABLE usuarios (
          id INT AUTO_INCREMENT PRIMARY KEY,
          nome VARCHAR(100) NOT NULL,
          email VARCHAR(100) UNIQUE NOT NULL,
          celular VARCHAR(15),
          senha VARCHAR(100) NOT NULL
        );
      ''');
      print("Tabela 'usuarios' criada com sucesso.");
    } else {
      print("Tabela 'usuarios' já existe.");
    }
  } catch (e) {
    print('Erro ao verificar ou criar tabela: $e');
  } finally {
    // Fechar a conexão
    await conn.close();
  }
}

Future<void> inserirUsuario(
    String nome, String email, String celular, String senha) async {
  // Conectar ao banco de dados
  var conn = await conectarBancoDeDados();

  try {
    // Inserir os dados na tabela
    var resultado = await conn.query(
      'INSERT INTO usuarios (nome, email, celular, senha) VALUES (?, ?, ?, ?)',
      [nome, email, celular, senha],
    );

    print('Usuário adicionado com ID: ${resultado.insertId}');
  } catch (e) {
    print('Erro ao inserir usuário: $e');
  } finally {
    // Fechar a conexão
    await conn.close();
  }
}

Future<bool> verificarCredenciais(String email, String senha) async {
  var conn = await conectarBancoDeDados();

  try {
    // Execute a consulta para verificar as credenciais
    var resultado = await conn.query(
        'SELECT * FROM usuarios WHERE email = ? AND senha = ?', [email, senha]);

    // Verifique se o resultado contém registros
    if (resultado.isNotEmpty) {
      print("Login bem-sucedido!");
      return true; // As credenciais estão corretas
    } else {
      print("Email ou senha incorretos.");
      return false; // Credenciais incorretas
    }
  } catch (e) {
    print('Erro ao verificar credenciais: $e');
    return false;
  } finally {
    await conn.close();
  }
}

// Temporário só pra testar se o DB está funcionando.
void buscarDados() async {
  try {
    var conn = await conectarBancoDeDados();

    var results = await conn.query('SELECT * FROM usuarios');

    for (var row in results) {
      print('Coluna 1: ${row[0]}, Coluna 2: ${row[1]}');
    }

    await conn.close();
  } catch (e) {
    print('Erro ao conectar ao banco de dados: $e');
  }
}
