import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sys/utils/extensions.dart';
import 'package:sys/widgets/custom_form_field.dart';

class Chamado extends StatefulWidget {
  final Future<List<String>> futurosTecnicos;
  final int usuarioId; // Adicionado para receber o ID do usuário

  const Chamado(
      {super.key, required this.futurosTecnicos, required this.usuarioId});

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
  late int usuarioId;

  List<Map<String, dynamic>> tecnicosDisponiveis = [];
  bool isLoadingTecnicos = true;

  @override
  void initState() {
    super.initState();
    fetchTecnicos();
  }

  Future<void> fetchTecnicos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    bool isAdmin = prefs.getBool('isAdmin') ?? false;

    final url = Uri.parse('http://localhost/databases/get-tecnicos.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({
          'userId': userId,
          'isAdmin': isAdmin,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tecnicosDisponiveis = data
              .map((tecnico) => {
                    'id': tecnico['id'], // Armazenando o ID
                    'nome': tecnico['nome'], // Armazenando o nome
                  })
              .toList();
          isLoadingTecnicos = false;
        });
      } else {
        throw Exception('Falha ao carregar técnicos disponíveis.');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoadingTecnicos = false;
      });
    }
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
      String status,
      int usuarioId) async {
    final url = Uri.parse('http://localhost/databases/criar-chamado.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
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
        'status': status,
        'usuario_id': usuarioId // Incluindo o ID do usuário
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success'] != null && responseBody['success']) {
        return true; // Chamado criado com sucesso
      } else {
        throw Exception('Falha ao criar chamado: ${responseBody['error']}');
      }
    } else {
      throw Exception('Erro ao criar chamado: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar chamado")),
      body: _buildUI(),
    );
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
                // Dropdown para selecionar técnicos
                isLoadingTecnicos
                    ? CircularProgressIndicator() // Carregando técnicos
                    : CustomDropdownField(
                        hintText: 'Técnico/Engenheiro',
                        items: tecnicosDisponiveis
                            .map((tecnico) => tecnico['nome'] as String)
                            .toList(),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Por favor, selecione uma opção';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            tecnico = val; // Armazenando o nome do técnico
                            usuarioId = tecnicosDisponiveis.firstWhere(
                                    (tecnico) => tecnico['nome'] == val)[
                                'id']; // Armazenando o ID do técnico
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
                        "$tecnico", // Agora é o nome do técnico
                        "$status",
                        usuarioId, // Agora é o ID do técnico
                      ).then((success) {
                        if (success) {
                          Navigator.pop(context,
                              true); // Retorna true para atualizar a lista
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao criar chamado.')),
                          );
                        }
                      }).catchError((error) {
                        print(error);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Erro inesperado ao criar chamado.')),
                        );
                      });
                    }
                  },
                  child: const Text('Criar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
