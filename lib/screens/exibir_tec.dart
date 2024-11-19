import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sys/screens/edit_tec.dart';
import 'package:sys/screens/formulario.dart';
import 'package:sys/screens/tec_chamados.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tecnico {
  String nome;
  String email;
  String celular;
  String status;
  int chamadosAtribuidos;

  Tecnico({
    required this.nome,
    required this.email,
    required this.celular,
    required this.status,
    required this.chamadosAtribuidos,
  });

  // Factory constructor to create Tecnico from JSON
  factory Tecnico.fromJson(Map<String, dynamic> json) {
    return Tecnico(
      nome: json['nome'] ?? 'Nome não disponível',
      email: json['email'] ?? 'Email não disponível',
      celular: json['celular'] ?? 'Celular não disponível',
      status: json['status'] ?? 'Status não disponível',
      chamadosAtribuidos: json['chamadosAtribuidos'] ?? 0,
    );
  }
}

class TecnicosListScreen extends StatefulWidget {
  @override
  _TecnicosListScreenState createState() => _TecnicosListScreenState();
}

class _TecnicosListScreenState extends State<TecnicosListScreen> {
  List<Tecnico> tecnicos = [];
  bool isLoading = true;
  bool isAdmin = false;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserDetails().then((_) => fetchTecnicos());
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getBool('isAdmin') ?? false;
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  Future<void> fetchTecnicos() async {
    final url = Uri.parse('http://localhost/databases/get-tecnicos.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({'userId': userId, 'isAdmin': isAdmin}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (var tecnicoJson in data) {
          // Buscando os chamados atribuídos para cada técnico
          final chamadosResponse = await http.get(
            Uri.parse(
                'http://localhost/databases/get-chamados-tecnico.php?tecnico=${Uri.encodeComponent(tecnicoJson['nome'])}'),
          );

          if (chamadosResponse.statusCode == 200) {
            final List<dynamic> chamados = json.decode(chamadosResponse.body);
            tecnicoJson['chamadosAtribuidos'] =
                chamados.length; // Atualiza a contagem de chamados
          } else {
            tecnicoJson['chamadosAtribuidos'] =
                0; // Se não houver chamados, define como 0
          }
        }

        setState(() {
          tecnicos = data.map((json) => Tecnico.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar técnicos');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Técnicos')),
      body: Center(
        // Centraliza o conteúdo
        child: isLoading
            ? CircularProgressIndicator()
            : tecnicos.isEmpty
                ? Text('Nenhum técnico disponível.')
                : Container(
                    constraints:
                        BoxConstraints(maxWidth: 600), // Limita a largura
                    child: ListView.builder(
                      itemCount: tecnicos.length,
                      itemBuilder: (context, index) {
                        final tecnico = tecnicos[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0), // Espaçamento entre os cards
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 4,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(tecnico.status),
                              radius: 5,
                            ),
                            title: Text(
                              tecnico.nome,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold, // Destaca o nome
                              ),
                            ),
                            subtitle: Text(
                              '${tecnico.status} - Chamados atribuídos: ${tecnico.chamadosAtribuidos}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            trailing: isAdmin
                                ? IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditTecnicoScreen(
                                                  tecnico: tecnico),
                                        ),
                                      );
                                    },
                                  )
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TecnicoChamadosScreen(tecnico: tecnico),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
            )
          : null,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disponível':
        return Colors.green;
      case 'Ocupado':
        return Colors.orange;
      case 'Ausente':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
