import 'package:flutter/material.dart';
import 'package:sys/screens/lista_chamados.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarChamadoScreen extends StatefulWidget {
  final ChamadoCriado chamado;

  EditarChamadoScreen({required this.chamado});

  @override
  _EditarChamadoScreenState createState() => _EditarChamadoScreenState();
}

class _EditarChamadoScreenState extends State<EditarChamadoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clienteController;
  late TextEditingController _equipamentoController;
  late TextEditingController _enderecoController;
  late TextEditingController _celularController;
  late TextEditingController _linkController;
  late TextEditingController _observacaoController;
  late TextEditingController _dataHoraController;
  late TextEditingController _chamadoController;

  String _tipo = 'Contrato';
  String _status = 'Aberto';
  String _tecnico = '';
  List<String> _tecnicos = [];

  @override
  void initState() {
    super.initState();
    _clienteController = TextEditingController(text: widget.chamado.cliente);
    _equipamentoController =
        TextEditingController(text: widget.chamado.equipamento);
    _enderecoController = TextEditingController(text: widget.chamado.endereco);
    _celularController = TextEditingController(text: widget.chamado.celular);
    _linkController = TextEditingController(text: widget.chamado.link);
    _observacaoController =
        TextEditingController(text: widget.chamado.observacao);
    _dataHoraController = TextEditingController(
        text: DateFormat('dd/MM/yyyy – HH:mm').format(widget.chamado.dataHora));

    _tipo = widget.chamado.tipo;
    _status = widget.chamado.status;
    _chamadoController = TextEditingController(text: widget.chamado.chamado);
    _tecnico = widget.chamado.tecnico;

    fetchTecnicos();
  }

  Future<void> fetchTecnicos() async {
    final response = await http
        .get(Uri.parse('http://localhost/databases/get-tecnicos.php'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          _tecnicos = jsonList.map((item) => item['nome'].toString()).toList();
          if (!_tecnicos.contains(_tecnico)) {
            _tecnicos.add(_tecnico);
          }
        });
      } catch (e) {
        print('Erro ao decodificar JSON: $e');
        throw Exception('Erro ao processar a resposta do servidor');
      }
    } else {
      throw Exception('Falha ao carregar técnicos');
    }
  }

  Future<void> _updateChamado() async {
    final url = Uri.parse(
        'http://localhost/databases/update-chamado.php?id=${widget.chamado.id}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'cliente': _clienteController.text,
        'equipamento': _equipamentoController.text,
        'endereco': _enderecoController.text,
        'celular': _celularController.text,
        'link': _linkController.text,
        'observacao': _observacaoController.text,
        'data': _dataHoraController.text,
        'tipo': _tipo,
        'status': _status,
        'chamado': _chamadoController.text,
        'tecnico': _tecnico,
      }),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erro ao atualizar chamado: ${jsonResponse['error']}')),
          );
        }
      } catch (e) {
        print('Erro ao decodificar JSON: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao processar resposta do servidor')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar chamado')),
      );
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _equipamentoController.dispose();
    _enderecoController.dispose();
    _celularController.dispose();
    _linkController.dispose();
    _observacaoController.dispose();
    _dataHoraController.dispose();
    _chamadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Chamado'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            constraints:
                BoxConstraints(maxWidth: 600), // Limita a largura máxima
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_clienteController, 'Cliente'),
                  _buildTextField(_chamadoController, "Chamado"),
                  _buildTextField(_equipamentoController, 'Equipamento'),
                  _buildTextField(_enderecoController, 'Endereço'),
                  _buildTextField(_celularController, 'Celular'),
                  _buildTextField(_linkController, 'Link Maps'),
                  _buildTextField(_observacaoController, 'Observação'),
                  _buildTextField(_dataHoraController, 'Data/Hora'),
                  _buildDropdown('Tipo', ['Contrato', 'Avulso'], _tipo,
                      (value) {
                    setState(() {
                      _tipo = value!;
                    });
                  }),
                  _buildDropdown(
                      'Status',
                      ['Aberto', 'Em Andamento', 'Finalizado'],
                      _status, (value) {
                    setState(() {
                      _status = value!;
                    });
                  }),
                  _buildDropdown('Técnico', _tecnicos, _tecnico, (value) {
                    setState(() {
                      _tecnico = value!;
                    });
                  }),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateChamado(); // Chama a função para atualizar o chamado
                        }
                      },
                      child: Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
