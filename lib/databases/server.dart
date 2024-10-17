import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:sys/databases/db.dart';

Future<void> main() async {
  final db = Database();
  await db.connect();

  final handler = (RequestContext context) async {
    final users = await db.getUsers();
    return Response.json(body: users);
  };

  final server = await serve(handler, 'localhost', 8080);
  print('Server listening on port ${server.port}');
}
