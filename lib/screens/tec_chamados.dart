import 'package:flutter/material.dart';
import 'package:sys/screens/exibir_tec.dart';
import 'package:sys/screens/lista_chamados.dart';

class TecnicoChamadosScreen extends StatelessWidget {
  final Tecnico tecnico;

  TecnicoChamadosScreen({required this.tecnico});

  @override
  Widget build(BuildContext context) {
    return ChamadosListScreen(tecnico: tecnico);
  }
}
