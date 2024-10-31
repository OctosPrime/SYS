import 'package:flutter/material.dart';
import 'package:sys/databases/db.dart';
import 'package:sys/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sys/screens/pag_inicial.dart';
import 'package:sys/utils/extensions.dart';
import 'package:sys/widgets/custom_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String? email, senha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login")), body: _buildUI());
  }

  Future<bool> verificarCredenciais(String email, String senha) async {
    final url = Uri.parse('http://10.0.2.2:3000/verificar-credenciais');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE"
      },
      body: json.encode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['success'];
    } else {
      throw Exception('Erro ao verificar credenciais');
    }
  }

  void entrar(String email, String senha) async {
    bool credenciaisValidas = await verificarCredenciais(email, senha);

    if (credenciaisValidas) {
      // Avançar para a próxima tela
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => PagInicial()));
      print("Login bem-sucedido. Avançando para a próxima tela.");
    } else {
      // Exibir mensagem de erro
      print("Falha no login. Verifique suas credenciais.");
      print({email, senha});
    }
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomFormField(
                hintText: 'Email',
                validator: (val) {
                  if (!val!.isValidEmail) {
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
              CustomFormField(
                hintText: 'Password',
                obscureText: true,
                validator: (val) {
                  if (!val!.isValidPassword) {
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
                    entrar("$email", "$senha");
                  }
                },
                child: const Text(
                  'Entrar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
