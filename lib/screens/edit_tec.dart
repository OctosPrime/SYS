import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sys/screens/exibir_tec.dart';

class EditTecnicoScreen extends StatefulWidget {
  final Tecnico tecnico;

  EditTecnicoScreen({required this.tecnico});

  @override
  _EditTecnicoScreenState createState() => _EditTecnicoScreenState();
}

class _EditTecnicoScreenState extends State<EditTecnicoScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _celularController;
  //late TextEditingController _statusController;
  //late TextEditingController _chamadosAtribuidosController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.tecnico.nome);
    _emailController = TextEditingController(text: widget.tecnico.email);
    _celularController = TextEditingController(text: widget.tecnico.celular);
    //_statusController = TextEditingController(text: widget.tecnico.status);
    //_chamadosAtribuidosController = TextEditingController(
    //text: widget.tecnico.chamadosAtribuidos.toString());
  }

  Future<void> _salvarTecnico() async {
    final url = Uri.parse(
        'http://localhost/databases/atualizar-tecnico/${widget.tecnico.nome}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': _nomeController.text,
        'email': _emailController.text,
        'celular': _celularController.text,
        //'status': _statusController.text,
        //'chamadosAtribuidos': int.parse(_chamadosAtribuidosController.text),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      // Handle error
      print('Failed to update tecnico');
    }
  }

  Future<void> _excluirTecnico() async {
    final url = Uri.parse(
        'http://localhost/databases/deletar-tecnico/${widget.tecnico.nome}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      // Handle error
      print('Failed to delete tecnico');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Técnico')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _celularController,
                decoration: InputDecoration(labelText: 'Celular'),
              ),
              // TextFormField(
              //   controller: _statusController,
              //   decoration: InputDecoration(labelText: 'Status'),
              // ),
              // TextFormField(
              //   controller: _chamadosAtribuidosController,
              //   decoration: InputDecoration(labelText: 'Chamados Atribuídos'),
              //   keyboardType: TextInputType.number,
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarTecnico,
                child: Text('Salvar'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _excluirTecnico,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color
                ),
                child: Text('Excluir Técnico'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _celularController.dispose();
    // _statusController.dispose();
    //_chamadosAtribuidosController.dispose();
    super.dispose();
  }
}
