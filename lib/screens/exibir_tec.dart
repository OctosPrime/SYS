import 'package:flutter/material.dart';
import 'package:sys/screens/detalhes_tec.dart';
import 'package:sys/screens/edit_tec.dart';
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
      nome: 'João Silva',
      email: 'joao@example.com',
      celular: '99999-9999',
      status: 'Disponível',
      chamadosAtribuidos: 0,
    ),
    Tecnico(
      nome: 'Maria Souza',
      email: 'maria@example.com',
      celular: '88888-8888',
      status: 'Ocupado',
      chamadosAtribuidos: 0,
    ),
    // Adicione mais técnicos conforme necessário
  ];

  final List<ChamadoCriado> todosChamados = [
    ChamadoCriado(
      tipo: 'Reparo',
      chamado: '12345',
      cliente: 'Cliente A',
      equipamento: 'Equipamento A',
      dataHora: DateTime.now(),
      endereco: 'Rua A, 123',
      celular: '99999-9999',
      observacao: 'Observação A',
      tecnico: 'João Silva',
      status: 'Aberto',
      link: 'https://maps.google.com?q=Rua+A,+123',
    ),
    ChamadoCriado(
      tipo: 'Instalação',
      chamado: '67890',
      cliente: 'Cliente B',
      equipamento: 'Equipamento B',
      dataHora: DateTime.now(),
      endereco: 'Rua B, 456',
      celular: '88888-8888',
      observacao: 'Observação B',
      tecnico: 'Maria Souza',
      status: 'Em Progresso',
      link: 'https://maps.google.com?q=Rua+B,+456',
    ),
    // Adicione mais chamados conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    tecnicos.forEach((tecnico) {
      tecnico.chamadosAtribuidos = todosChamados
          .where((chamado) => chamado.tecnico == tecnico.nome)
          .length;
    });
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
              title: Text(tecnico.nome),
              subtitle:
                  Text('Chamados atribuídos: ${tecnico.chamadosAtribuidos}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTecnicoScreen(tecnico: tecnico),
                    ),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TecnicoChamadosScreen(
                      tecnico: tecnico,
                      todosChamados: todosChamados,
                    ),
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
