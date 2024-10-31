import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sys/utils/extensions.dart';
import 'package:sys/widgets/custom_form_field.dart';

class Chamado extends StatefulWidget {
  const Chamado({super.key});

  @override
  State<Chamado> createState() => _ChamadoState();
}

class _ChamadoState extends State<Chamado> {
  final _formKey = GlobalKey<FormState>();

  String? tipo,
      chamado,
      cliente,
      equipamento,
      data,
      hora,
      endereco,
      celular,
      link,
      observacao,
      tecnico,
      status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar chamado")),
      body: _buildUI(),
    );
  }

  Future<bool> criarChamado(
      String tipo,
      String chamado,
      String cliente,
      String equipamento,
      DateTime dateTime,
      String endereco,
      String celular,
      String link,
      String observacao,
      String tecnico,
      String status) async {
    final url = Uri.parse('http://localhost:3000/criar-chamado');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE"
      },
      body: json.encode({
        'tipo': tipo,
        'chamado': chamado,
        'cliente': cliente,
        'equipamento': equipamento,
        'data': dateTime.toIso8601String(),
        'endereco': endereco,
        'celular': celular,
        'link': link,
        'observacao': observacao,
        'tecnico': tecnico,
        'status': status
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['success'];
    } else {
      throw Exception('Erro ao criar chamado.');
    }
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomDropdownField(
                  hintText: 'Tipo de chamado',
                  items: ["Contrato", "Avulso"],
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Por favor, selecione uma opção';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      tipo = val;
                    });
                  },
                ),
                CustomFormField(
                  hintText: 'Número do chamado',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Coloque um número de chamado correspondente.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      chamado = val;
                    });
                  },
                ),
                CustomFormField(
                  hintText: 'Cliente',
                  validator: (val) {
                    if (!val!.isValidName) {
                      return 'Coloque um nome válido (Primeira letra maiúscula).';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      cliente = val;
                    });
                  },
                ),
                CustomFormField(
                  hintText: 'Equipamento',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Coloque nome do equipamento.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      equipamento = val;
                    });
                  },
                ),
                CustomDatePickerField(
                  hintText: 'Selecione uma data',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Por favor, selecione uma data';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      data = val;
                    });
                  },
                ),
                CustomTimePickerField(
                  hintText: 'Selecione um horário',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Por favor, selecione um horário';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      hora = val;
                    });
                  },
                ),
                CustomFormField(
                  hintText: 'Endereço',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Coloque um endereço válido.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      endereco = val;
                    });
                  },
                ),
                CustomFormField(
                  hintText: 'Telefone de contato',
                  validator: (val) {
                    if (!val!.isValidPhone) {
                      return 'Coloque um número válido.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      celular = val;
                    });
                  },
                ),
                CustomFormField(
                  hintText: 'Link para o mapa',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Coloque um link de navegação.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      link = val;
                    });
                  },
                ),
                CustomLargeTextField(
                  hintText: 'Observação',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Por favor, insira um texto';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      observacao = val;
                    });
                  },
                ),
                CustomDropdownField(
                  hintText: 'Técnico/Engenheiro',
                  items: ["Teste Um", "Teste Dois"],
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Por favor, selecione uma opção';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      tecnico = val;
                    });
                  },
                ),
                CustomDropdownField(
                  hintText: 'Status',
                  items: ["Aberto", "Agendado", "Em Andamento", "Finalizado"],
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Por favor, selecione uma opção';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      status = val;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String dateString = "$data $hora";
                      DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm a");
                      DateTime dateTime = dateFormat.parse(dateString, true);

                      criarChamado(
                        "$tipo",
                        "$chamado",
                        "$cliente",
                        "$equipamento",
                        dateTime,
                        "$endereco",
                        "$celular",
                        "$link",
                        "$observacao",
                        "$tecnico",
                        "$status",
                      ).then((success) {
                        if (success) {
                          Navigator.pop(context,
                              true); // Retorna true para atualizar a lista
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao criar chamado.'),
                            ),
                          );
                        }
                      });
                    }
                  },
                  child: const Text('Criar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
