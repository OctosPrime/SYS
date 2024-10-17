import 'package:postgres/postgres.dart';

class Database {
  late final _connection;

  Future<void> connect() async {
    _connection = await Connection.open(Endpoint(
      host: 'sysmedbd.postgresql.dbaas.com.br',
      database: 'sysmedbd',
      username: 'sysmedb',
      password: 'SysMedicaBd1@',
    ));
  }

  Future<void> createTable() async {
    await _connection.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        phone VARCHAR(15) NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertUser(
      String name, String email, String phone, String password) async {
    await _connection!.execute('''
      INSERT INTO users (name, email, phone, password) VALUES (@name, @mail, @phone, @password)
    ''', substitutionValues: {
      'name': name,
      'mail': email,
      'phone': phone,
      'password': password,
    });
  }

  // Add other CRUD operations here
}
