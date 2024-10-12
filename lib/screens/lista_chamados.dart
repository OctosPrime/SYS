import 'package:flutter/material.dart';
import 'package:sys/screens/chamado.dart';
import 'package:sys/screens/detalhes_chamado.dart';

class ChamadoCriado {
  String tipo;
  String chamado;
  String cliente;
  String equipamento;
  DateTime dataHora;
  String endereco;
  String celular;
  String link;
  String observacao;
  String tecnico;
  String status;

  ChamadoCriado({
    required this.tipo,
    required this.chamado,
    required this.cliente,
    required this.equipamento,
    required this.dataHora,
    required this.endereco,
    required this.celular,
    required this.link,
    required this.observacao,
    required this.tecnico,
    required this.status,
  });
}

class ChamadosListScreen extends StatelessWidget {
  final List<ChamadoCriado> chamados;

  ChamadosListScreen({required this.chamados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chamados')),
      body: ListView.builder(
        itemCount: chamados.length,
        itemBuilder: (context, index) {
          final chamado = chamados[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChamadoDetailScreen(chamado: chamado),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${chamado.chamado} - ${chamado.cliente}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: _getStatusColor(chamado.status),
                              radius: 5,
                            ),
                            SizedBox(width: 8),
                            Text(
                              chamado.status,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Técnico: ${chamado.tecnico}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${chamado.dataHora}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            chamado.endereco,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chamado()),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aberto':
        return Colors.green;
      case 'Em Andamento':
        return Colors.orange;
      case 'Finalizado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
