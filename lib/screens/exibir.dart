import 'package:flutter/material.dart';

class exibir extends StatelessWidget {
  final String? nome;
  const exibir({this.nome ,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$nome"),
        ),
        body: Center(
          child: Text('Recebeu data: $nome')
        )
    );
  }
}