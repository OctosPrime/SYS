import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:sys/screens/edit_chamado.dart';
import 'package:sys/screens/lista_chamados.dart';

class ChamadoDetailScreen extends StatelessWidget {
  final ChamadoCriado chamado;

  ChamadoDetailScreen({required this.chamado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Chamado')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chamado: ${chamado.chamado}'),
            Text('Cliente: ${chamado.cliente}'),
            Text('Equipamento: ${chamado.equipamento}'),
            Text('Data/Hora: ${chamado.dataHora}'),
            Text('Endereço: ${chamado.endereco}'),
            Text('Celular: ${chamado.celular}'),
            Text('Link Maps: ${chamado.link}'),
            Text('Observação: ${chamado.observacao}'),
            Text('Técnico: ${chamado.tecnico}'),
            Text('Status: ${chamado.status}'),
            //   GestureDetector(
            //       onTap: () async {
            //         final url = Uri.parse(chamado.link);
            //         if (await canLaunchUrl(url)) {
            //           await launchUrl(url);
            //         } else {
            //           throw 'Could not launch $url';
            //         }
            //       },
            //     child: Text(
            //       'Abrir no Google Maps',
            //       style: TextStyle(
            //         color: Colors.blue,
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditChamadoScreen(chamado: chamado),
            ),
          );
        },
      ),
    );
  }
}
