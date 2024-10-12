import 'package:flutter/material.dart';
import 'package:sys/screens/exibir_tec.dart';
import 'package:sys/screens/lista_chamados.dart';

class TecnicoChamadosScreen extends StatelessWidget {
  final Tecnico tecnico;
  final List<ChamadoCriado> todosChamados;

  TecnicoChamadosScreen({required this.tecnico, required this.todosChamados});

  @override
  Widget build(BuildContext context) {
    // Filtra os chamados do técnico selecionado
    final chamadosFiltrados = todosChamados
        .where((chamado) => chamado.tecnico == tecnico.nome)
        .toList();

    return ChamadosListScreen(chamados: chamadosFiltrados);
  }
}
