import 'package:flutter/material.dart';
import 'package:sys/utils/extensions.dart';
import 'package:sys/widgets/login_field.dart';

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
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
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
