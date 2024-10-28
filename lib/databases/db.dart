import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> conectarBancoDeDados() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'sysmedicalapp.mysql.dbaas.com.br',
    port: 3306, // Porta padrão do MySQL
    user: 'sysmedicalapp',
    db: 'sysmedicalapp',
    password: 'SysMedical123!',
  ));

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

  return conn;
}
