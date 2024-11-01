import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sys/screens/pag_inicial.dart';
import 'package:sys/utils/extensions.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? email, senha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(context),
      //backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Future<bool> verificarCredenciais(String email, String senha) async {
    final url = Uri.parse(
        'http://localhost:3000/verificar-credenciais'); // 10.0.2.2:3000 para teste Android
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE'
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
    setState(() {
      _isLoading = true;
    });

    bool credenciaisValidas = await verificarCredenciais(email, senha);

    setState(() {
      _isLoading = false;
    });

    if (credenciaisValidas) {
      // Avançar para a próxima tela
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PagInicial()));
      print("Login bem-sucedido. Avançando para a próxima tela.");
    } else {
      // Exibir mensagem de erro
      _showErrorDialog("Falha no login. Verifique suas credenciais.");
      print("Falha no login. Verifique suas credenciais.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth * 0.8;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 150,
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Container(
                    width: formWidth > 400 ? 400 : formWidth,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
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
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
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
                        SizedBox(height: 30),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    entrar(email!, senha!);
                                  }
                                },
                                icon: Icon(Icons.login),
                                label: Text('Entrar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
