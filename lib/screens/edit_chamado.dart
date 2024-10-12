import 'package:flutter/material.dart';
import 'package:sys/screens/lista_chamados.dart';

class EditChamadoScreen extends StatefulWidget {
  final ChamadoCriado chamado;

  EditChamadoScreen({required this.chamado});

  @override
  _EditChamadoScreenState createState() => _EditChamadoScreenState();
}

class _EditChamadoScreenState extends State<EditChamadoScreen> {
  late TextEditingController _tipoController;
  late TextEditingController _chamadoController;
  late TextEditingController _clienteController;
  late TextEditingController _equipamentoController;
  late TextEditingController _dataHoraController;
  late TextEditingController _enderecoController;
  late TextEditingController _celularController;
  late TextEditingController _linkController;
  late TextEditingController _observacaoController;
  late TextEditingController _tecnicoController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _tipoController = TextEditingController(text: widget.chamado.tipo);
    _chamadoController = TextEditingController(text: widget.chamado.chamado);
    _clienteController = TextEditingController(text: widget.chamado.cliente);
    _equipamentoController =
        TextEditingController(text: widget.chamado.equipamento);
    _dataHoraController =
        TextEditingController(text: widget.chamado.dataHora.toString());
    _enderecoController = TextEditingController(text: widget.chamado.endereco);
    _celularController = TextEditingController(text: widget.chamado.celular);
    _linkController = TextEditingController(text: widget.chamado.link);
    _observacaoController =
        TextEditingController(text: widget.chamado.observacao);
    _tecnicoController = TextEditingController(text: widget.chamado.tecnico);
    _statusController = TextEditingController(text: widget.chamado.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Chamado')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
                controller: _tipoController,
                decoration: InputDecoration(labelText: 'Tipo')),
            TextField(
                controller: _chamadoController,
                decoration: InputDecoration(labelText: 'Chamado')),
            TextField(
                controller: _clienteController,
                decoration: InputDecoration(labelText: 'Cliente')),
            TextField(
                controller: _equipamentoController,
                decoration: InputDecoration(labelText: 'Equipamento')),
            TextField(
                controller: _dataHoraController,
                decoration: InputDecoration(labelText: 'Data/Hora')),
            TextField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço')),
            TextField(
                controller: _celularController,
                decoration: InputDecoration(labelText: 'Celular')),
            TextField(
                controller: _linkController,
                decoration: InputDecoration(labelText: 'Link Maps')),
            TextField(
                controller: _observacaoController,
                decoration: InputDecoration(labelText: 'Observação')),
            TextField(
                controller: _tecnicoController,
                decoration: InputDecoration(labelText: 'Técnico')),
            TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.chamado.tipo = _tipoController.text;
                  widget.chamado.chamado = _chamadoController.text;
                  widget.chamado.cliente = _clienteController.text;
                  widget.chamado.equipamento = _equipamentoController.text;
                  widget.chamado.dataHora =
                      DateTime.parse(_dataHoraController.text);
                  widget.chamado.endereco = _enderecoController.text;
                  widget.chamado.celular = _celularController.text;
                  widget.chamado.observacao = _observacaoController.text;
                  widget.chamado.tecnico = _tecnicoController.text;
                  widget.chamado.status = _statusController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _chamadoController.dispose();
    _clienteController.dispose();
    _equipamentoController.dispose();
    _dataHoraController.dispose();
    _enderecoController.dispose();
    _celularController.dispose();
    _observacaoController.dispose();
    _tecnicoController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}
