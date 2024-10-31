import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sys/screens/edit_tec.dart';
import 'package:sys/screens/formulario.dart';
import 'package:sys/screens/tec_chamados.dart';

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
      nome: json['nome'] ?? 'Nome não disponível', // valor padrão
      email: json['email'] ?? 'Email não disponível', // valor padrão
      celular: json['celular'] ?? 'Celular não disponível', // valor padrão
      status: json['status'] ?? 'Status não disponível', // valor padrão
      chamadosAtribuidos: json['chamadosAtribuidos'] ?? 0, // valor padrão
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

  @override
  void initState() {
    super.initState();
    fetchTecnicos();
  }

  Future<void> fetchTecnicos() async {
    final url =
        Uri.parse('http://localhost:3000/api/tecnicos'); // URL da sua API
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tecnicos = data
              .map((json) => Tecnico.fromJson(json))
              .toList(); // mapeia os dados para a lista de técnicos
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar técnicos');
      }
    } catch (e) {
      print(e);
      // Trate o erro, como exibir um SnackBar ou diálogo de erro
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Técnicos')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tecnicos.isEmpty
              ? Center(
                  child: Text(
                      'Nenhum técnico disponível.')) // mensagem para lista vazia
              : ListView.builder(
                  itemCount: tecnicos.length,
                  itemBuilder: (context, index) {
                    final tecnico = tecnicos[index];
                    return Card(
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
                          ),
                        ),
                        subtitle: Text(
                            'Chamados atribuídos: ${tecnico.chamadosAtribuidos}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditTecnicoScreen(tecnico: tecnico),
                              ),
                            );
                          },
                        ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Register()),
          );
        },
      ),
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
