import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

  factory ChamadoCriado.fromJson(Map<String, dynamic> json) {
    return ChamadoCriado(
      tipo: json['tipo'],
      chamado: json['chamado'],
      cliente: json['cliente'],
      equipamento: json['equipamento'],
      dataHora: DateTime.parse(json['data']),
      endereco: json['endereco'],
      celular: json['celular'],
      link: json['link'],
      observacao: json['observacao'],
      tecnico: json['tecnico'],
      status: json['status'],
    );
  }
}

class ChamadosListScreen extends StatefulWidget {
  final Tecnico? tecnico; // Mantém a referência ao técnico

  ChamadosListScreen({this.tecnico});

  @override
  _ChamadosListScreenState createState() => _ChamadosListScreenState();
}

class _ChamadosListScreenState extends State<ChamadosListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<ChamadoCriado>> futurosChamados;
  late TabController _tabController;
  final List<String> _statuses = [
    'Todos',
    'Aberto',
    'Em Andamento',
    'Finalizado',
    'Agendado'
  ];
  String _selectedStatus = 'Todos';

  @override
  void initState() {
    super.initState();
    futurosChamados = fetchChamados();
    _tabController = TabController(length: _statuses.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedStatus = _statuses[_tabController.index];
      });
    });
  }

  Future<List<ChamadoCriado>> fetchChamados() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/chamados'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      // Filtrar por técnico, se necessário
      if (widget.tecnico != null) {
        jsonResponse = jsonResponse
            .where((chamado) => chamado['tecnico'] == widget.tecnico!.nome)
            .toList();
      }

      return jsonResponse
          .map((chamado) => ChamadoCriado.fromJson(chamado))
          .toList();
    } else {
      throw Exception('Falha ao carregar chamados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tecnico == null
            ? 'Todos os Chamados'
            : 'Chamados de ${widget.tecnico!.nome}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Voltar e indicar atualização
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _statuses.map((status) => Tab(text: status)).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Center(
        child: FutureBuilder<List<ChamadoCriado>>(
          future: futurosChamados,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else {
              List<ChamadoCriado> chamados = snapshot.data!;

              // Filtra os chamados de acordo com o status selecionado
              if (_selectedStatus != 'Todos') {
                chamados = chamados
                    .where((chamado) => chamado.status == _selectedStatus)
                    .toList();
              }

              return Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: ListView.builder(
                  itemCount: chamados.length,
                  itemBuilder: (context, index) {
                    final chamado = chamados[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChamadoDetailScreen(chamado: chamado),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        backgroundColor:
                                            _getStatusColor(chamado.status),
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
                                      SizedBox(width: 8),
                                      Text(
                                        chamado.tipo,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Técnico: ${chamado.tecnico}',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy – HH:mm')
                                    .format(chamado.dataHora),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                chamado.endereco,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bool shouldRefresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chamado()),
              ) ??
              false;

          if (shouldRefresh) {
            setState(() {
              futurosChamados = fetchChamados(); // Atualiza a lista de chamados
            });
          }
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
      case 'Agendado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
