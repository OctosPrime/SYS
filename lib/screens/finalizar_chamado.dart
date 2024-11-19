import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sys/screens/lista_chamados.dart';

class ConclusaoChamadoDialog extends StatefulWidget {
  final ChamadoCriado chamado;

  ConclusaoChamadoDialog({required this.chamado});

  @override
  _ConclusaoChamadoDialogState createState() => _ConclusaoChamadoDialogState();
}

class _ConclusaoChamadoDialogState extends State<ConclusaoChamadoDialog> {
  late TextEditingController _observacaoController;
  late String _status;
  late DateTime _dataConclusao;

  @override
  void initState() {
    super.initState();
    _observacaoController =
        TextEditingController(text: widget.chamado.observacao);
    _status = 'Em Andamento';
    _dataConclusao = DateTime.now();
  }

  Future<void> _enviarDados() async {
    // Lógica para enviar dados ao banco de dados e ao OneDrive.
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Conclusão do Chamado'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Técnico: ${widget.chamado.tecnico}'),
            Text('Chamado: ${widget.chamado.chamado}'),
            Text('Cliente: ${widget.chamado.cliente}'),
            Text('Equipamento: ${widget.chamado.equipamento}'),
            Text('Data/Hora Agendada: ${widget.chamado.dataHora}'),
            Text('Link do Mapa: ${widget.chamado.link}'),
            TextField(
              controller: _observacaoController,
              decoration: InputDecoration(labelText: 'Observações'),
            ),
            DropdownButton<String>(
              value: _status,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['Em Andamento', 'Finalizar']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Data de Conclusão'),
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(_dataConclusao),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dataConclusao,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _dataConclusao)
                  setState(() {
                    _dataConclusao = pickedDate;
                  });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            _enviarDados();
            Navigator.of(context).pop();
          },
          child: Text('Enviar'),
        ),
      ],
    );
  }
}
