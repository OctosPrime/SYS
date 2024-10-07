import 'package:flutter/material.dart';
import 'package:sys/screens/exibir.dart';

class PagInicial extends StatelessWidget {
  const PagInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exibição")),
      body: _buildUI(context),
    );
  }
}

Widget _buildUI(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Navegar para a tela ExibirScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => exibir()),
              );
            },
            child: const Text('Ir para ExibirScreen'),
          ),
        ],
      ),
    ),
  );
}
