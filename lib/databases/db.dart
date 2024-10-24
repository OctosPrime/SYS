// import 'package:postgres/postgres.dart';

// ignore: camel_case_types
// class database {
//   ignore: prefer_typing_uninitialized_variables
//   late final _connection;

//   Future<void> connect() async {
//     try {
//       _connection = await Connection.open(Endpoint(
//         host: 'sysmedbd.postgresql.dbaas.com.br',
//         database: 'sysmedbd',
//         username: 'sysmedbd',
//         password: 'SysMedicalBd1@',
//       ));
//       print(_connection - "conectou");
//     } catch (e) {
//       print("error");
//     }
//   }

//   Future<void> createTable() async {
//     await _connection.execute('''
//       CREATE TABLE IF NOT EXISTS users (
//         id SERIAL PRIMARY KEY,
//         name VARCHAR(100) NOT NULL,
//         email VARCHAR(100) NOT NULL UNIQUE,
//         phone VARCHAR(15) NOT NULL,
//         password TEXT NOT NULL
//       )
//     ''');
//     print("deu certo");
//   }

//   Future<void> insertUser(
//       String name, String email, String phone, String password) async {
//     await _connection!.execute('''
//       INSERT INTO users (name, email, phone, password) VALUES (@name, @mail, @phone, @password)
//     ''', substitutionValues: {
//       'name': name,
//       'mail': email,
//       'phone': phone,
//       'password': password,
//     });
//   }

  // Add other CRUD operations here
//}
