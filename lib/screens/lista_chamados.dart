import 'package:flutter/material.dart';
import 'package:sys/screens/chamado.dart';
import 'package:sys/screens/detalhes_chamado.dart';
import 'package:sys/screens/exibir_tec.dart';

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
  final Tecnico? tecnico;

  ChamadosListScreen({this.tecnico});

  final List<ChamadoCriado> chamados = [
    ChamadoCriado(
      tipo: 'Manutenção',
      chamado: '78954',
      cliente: 'Charlinda Queiros',
      equipamento: 'Raio X',
      dataHora: DateTime.now(),
      endereco: 'Rua Raio Queoparta, 2032',
      celular: '99999-9999',
      link: "https://maps.app.goo.gl/a6qk5kxjg5RwZQR76",
      observacao: 'Raio X com diversos defeitos físicos e de software',
      tecnico: 'Welton Ulkovski',
      status: 'Em Andamento',
    ),
    ChamadoCriado(
      tipo: 'Manutenção',
      chamado: '45672',
      cliente: 'Judith Pereira SA',
      equipamento: 'Impressora',
      dataHora: DateTime.now(),
      endereco: 'Rua João Paulo, 1508',
      celular: '67998421321',
      link: "https://maps.app.goo.gl/a6qk5kxjg5RwZQR76",
      observacao: 'Maquina quase toda quebrada',
      tecnico: 'Carina Uchiha',
      status: 'Aberto',
    ),
    ChamadoCriado(
      tipo: 'Manutenção',
      chamado: '98751',
      cliente: 'Cassems Luciano',
      equipamento: 'Impressora',
      dataHora: DateTime.now(),
      endereco: 'Rua Alcídes Melquíades, 1072',
      celular: '6798484241',
      link: "https://maps.app.goo.gl/a6qk5kxjg5RwZQR76",
      observacao: 'Observação A',
      tecnico: 'Jorge Botafogo',
      status: 'Finalizado',
    ),
    // Adicione mais chamados conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    final List<ChamadoCriado> chamadosFiltrados = tecnico == null
        ? chamados
        : chamados
            .where((chamado) => chamado.tecnico == tecnico!.nome)
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(tecnico == null
            ? 'Todos os Chamados'
            : 'Chamados de ${tecnico!.nome}'),
      ),
      body: ListView.builder(
        itemCount: chamadosFiltrados.length,
        itemBuilder: (context, index) {
          final chamado = chamadosFiltrados[index];
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
