import 'package:flutter/material.dart';
import 'package:sys/screens/exibir_tec.dart';
import 'package:sys/screens/lista_chamados.dart';

class PagInicial extends StatelessWidget {
  const PagInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém a largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    // Define a largura dos botões com base na largura da tela
    final buttonWidth = screenWidth * 0.8; // 80% da largura da tela

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            height: 100, // Ajuste conforme necessário
          ),
        ),
        toolbarHeight: 130,
      ),
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
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChamadosListScreen(), // Passando a lista
                    ),
                  ); //tem que exibir a tela de chamados disponíveis.
                },
                icon: Icon(Icons.list),
                label: Text('Lista de Chamados'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  surfaceTintColor: Colors.white,
                  minimumSize: Size(buttonWidth,
                      50), // Garante que o botão preencha a largura do SizedBox
                ),
              ),
              const SizedBox(height: 30), // Espaçamento entre os botões
              ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           exibir()), //tem que exibir a tela de ordens de serviços disponíveis
                  // );
                },
                icon: Icon(Icons.build),
                label: Text('Lista de Ordens de Serviço'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  surfaceTintColor: Colors.white,
                  minimumSize: Size(buttonWidth, 50),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TecnicosListScreen()), //tem que exibir a tela de técnicos cadastrados.
                  );
                },
                icon: Icon(Icons.person),
                label: Text('Lista de Técnicos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  surfaceTintColor: Colors.white,
                  minimumSize: Size(buttonWidth, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
