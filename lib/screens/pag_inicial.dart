import 'package:flutter/material.dart';
import 'package:sys/main.dart';
import 'package:sys/screens/chamado.dart';
import 'package:sys/screens/exibir_tec.dart';
import 'package:sys/screens/lista_chamados.dart';
import 'package:sys/screens/tec_chamados.dart';

class PagInicial extends StatelessWidget {
  const PagInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém a largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    // Define a largura dos botões com base na largura da tela
    final buttonWidth = screenWidth * 0.4; // 80% da largura da tela

    return Scaffold(
      appBar: AppBar(title: const Text("Exibição")),
      body: _buildUI(context, buttonWidth),
    );
  }
}

Widget _buildUI(BuildContext context, double buttonWidth) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: SizedBox(
          width:
              buttonWidth, // Define a largura do SizedBox que conterá os botões
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChamadosListScreen(), // Passando a lista
                    ),
                  ); //tem que exibir a tela de chamados disponiveis.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  minimumSize: Size(buttonWidth,
                      50), // Garante que o botão preencha a largura do SizedBox
                ),
                child: const Text('Lista de Chamados'),
              ),
              const SizedBox(height: 30), // Espaçamento entre os botões
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           exibir()), //tem que exibir a tela de ordens de serviços disponiveis
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  minimumSize: Size(buttonWidth, 50),
                ),
                child: const Text('Lista de Ordens de Serviço'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TecnicosListScreen()), //tem que exibir a tela de técnicos cadastrados.
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  minimumSize: Size(buttonWidth, 50),
                ),
                child: const Text('Lista de Técnicos'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
