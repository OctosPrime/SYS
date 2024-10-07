import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sys/screens/exibir.dart';

class PagInicial extends StatelessWidget {
  const PagInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exibição")), body: _buildUI()
    );
  }
}

Widget _buildUI() {
  return SafeArea(
    child: Padding(padding: const EdgeInsets.all(
        10.0,
      ),
      
      child: ElevatedButton(
        onPressed: () {
          Navigator.push();
        },
        child: const Text(
                'Lista de Chamados'),
      ),
    )
  );
}