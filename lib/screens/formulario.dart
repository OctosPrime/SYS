import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sys/screens/exibir_tec.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String? nome, email, celular, senha;

  Future<void> inserirUsuario(
      String nome, String email, String celular, String senha) async {
    final url = Uri.parse('http://localhost:3000/api/tecnicos');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': nome,
        'email': email,
        'celular': celular,
        'senha': senha,
      }),
    );

    if (response.statusCode == 201) {
      // Supondo que a API retorna o ID do técnico criado
      final data = json.decode(response.body);
      final id = data['id'];
      // Aqui você pode navegar para a lista de técnicos ou fazer outra ação
    } else {
      // Lide com o erro
      print('Falha ao criar técnico');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Técnico")),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Coloque um nome válido.';
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    nome = val;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) {
                  if (val == null ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                    return 'Coloque um email válido.';
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Celular'),
                validator: (val) {
                  if (val == null ||
                      !RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(val)) {
                    return 'Coloque um número válido.';
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    celular = val;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (val) {
                  if (val == null || val.length < 6) {
                    return 'Coloque uma senha válida.';
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    senha = val;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    inserirUsuario(nome!, email!, celular!, senha!);
                    Navigator.pop(context, true); // Retornar à tela anterior
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
