import 'package:flutter/material.dart';
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
  late TextEditingController _statusController;
  late TextEditingController _chamadosAtribuidosController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.tecnico.nome);
    _emailController = TextEditingController(text: widget.tecnico.email);
    _celularController = TextEditingController(text: widget.tecnico.celular);
    _statusController = TextEditingController(text: widget.tecnico.status);
    _chamadosAtribuidosController = TextEditingController(
        text: widget.tecnico.chamadosAtribuidos.toString());
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
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: _chamadosAtribuidosController,
                decoration: InputDecoration(labelText: 'Chamados Atribuídos'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Atualizar os dados do técnico
                  setState(() {
                    widget.tecnico.nome = _nomeController.text;
                    widget.tecnico.email = _emailController.text;
                    widget.tecnico.celular = _celularController.text;
                    widget.tecnico.status = _statusController.text;
                    widget.tecnico.chamadosAtribuidos =
                        int.parse(_chamadosAtribuidosController.text);
                  });
                  Navigator.pop(context);
                },
                child: Text('Salvar'),
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
    _statusController.dispose();
    _chamadosAtribuidosController.dispose();
    super.dispose();
  }
}
