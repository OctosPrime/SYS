import 'package:flutter/material.dart';
import 'package:sys/utils/extensions.dart';
import 'package:sys/widgets/custom_form_field.dart';
import 'package:sys/screens/exibir_tec.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String? nome, email, celular, senha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Register")), body: _buildUI());
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
                hintText: 'Nome',
                validator: (val) {
                  if (!val!.isValidName) {
                    return 'Coloque um nome válido (Primeira letra precisa ser maiúscula).';
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    nome = val;
                  });
                },
              ),
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
                hintText: 'Celular',
                validator: (val) {
                  if (!val!.isValidPhone) {
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
                    print("o email é $nome");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TecnicosListScreen()));
                  }
                },
                child: const Text(
                  'Register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
