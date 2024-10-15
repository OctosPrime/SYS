import 'package:flutter/material.dart';
import 'package:sys/screens/formulario.dart';
import 'package:sys/screens/lista_chamados.dart';
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
}

class TecnicosListScreen extends StatelessWidget {
  final List<Tecnico> tecnicos = [
    Tecnico(
      nome: 'Welton Ulkovski',
      email: 'welton@hotmail.com',
      celular: '99999-9999',
      status: 'Disponível',
      chamadosAtribuidos: 5,
    ),
    Tecnico(
      nome: 'Carina Uchiha',
      email: 'carina@gmail.com',
      celular: '88888-8888',
      status: 'Ocupado',
      chamadosAtribuidos: 3,
    ),
    // Adicione mais técnicos conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Técnicos')),
      body: ListView.builder(
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
              subtitle:
                  Text('Chamados atribuídos: ${tecnico.chamadosAtribuidos}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChamadosListScreen(tecnico: tecnico),
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
