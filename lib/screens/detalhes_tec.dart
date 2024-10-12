import 'package:flutter/material.dart';
import 'package:sys/screens/edit_tec.dart';
import 'package:sys/screens/exibir_tec.dart';

class TecnicoDetailScreen extends StatelessWidget {
  final Tecnico tecnico;

  TecnicoDetailScreen({required this.tecnico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Técnico')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Nome: ${tecnico.nome}'),
            Text('Email: ${tecnico.email}'),
            Text('Celular: ${tecnico.celular}'),
            Text('Status: ${tecnico.status}'),
            Text('Chamados atribuídos: ${tecnico.chamadosAtribuidos}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditTecnicoScreen(tecnico: tecnico)),
          );
        },
      ),
    );
  }
}
