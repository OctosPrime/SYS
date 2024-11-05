import 'package:flutter/material.dart';
import 'package:sys/screens/lista_chamados.dart';
//import 'package:url_launcher/url_launcher.dart'; // Certifique-se de que está importado
import 'package:sys/screens/edit_chamado.dart';

class ChamadoDetailScreen extends StatelessWidget {
  final ChamadoCriado chamado;

  ChamadoDetailScreen({required this.chamado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Chamado'),
        centerTitle: true,
      ),
      body: Center(
        // Centraliza o conteúdo na tela
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints:
                BoxConstraints(maxWidth: 600), // Limita a largura máxima
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailCard('Chamado', chamado.chamado),
                  _buildDetailCard('Cliente', chamado.cliente),
                  _buildDetailCard('Equipamento', chamado.equipamento),
                  _buildDetailCard('Data/Hora', chamado.dataHora.toString()),
                  _buildDetailCard('Endereço', chamado.endereco),
                  _buildDetailCard('Celular', chamado.celular),
                  _buildDetailCard('Link Maps', chamado.link, isLink: true),
                  _buildDetailCard('Observação', chamado.observacao),
                  _buildDetailCard('Técnico', chamado.tecnico),
                  _buildDetailCard('Status', chamado.status),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          bool? shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditarChamadoScreen(chamado: chamado),
            ),
          );

          if (shouldRefresh == true) {
            Navigator.pop(context, true); // Voltar e indicar atualização
          }
        },
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, {bool isLink = false}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // if (isLink)
            //   GestureDetector(
            //     onTap: () async {
            //       final Uri url = Uri.parse(value);
            //       if (await canLaunch(url.toString())) {
            //         await launch(url.toString());
            //       } else {
            //         throw 'Could not launch $url';
            //       }
            //     },
            //     child: Text(
            //       value,
            //       style: TextStyle(
            //         color: Colors.blue,
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   )
            // else
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
