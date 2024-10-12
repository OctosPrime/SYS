import 'package:flutter/material.dart';
import 'package:sys/utils/extensions.dart';
import 'package:sys/widgets/custom_form_field.dart';
import 'package:sys/screens/exibir_tec.dart';

class Chamado extends StatefulWidget {
  const Chamado({super.key});

  @override
  State<Chamado> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Chamado> {
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
        appBar: AppBar(title: const Text("Criar chamado")), body: _buildUI());
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
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
                  obscureText: true,
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
                  hintText: 'Selecione uma horário',
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
                  hintText: 'Endereço (Ex: Rua João Falco, 188, Moreninha)',
                  obscureText: true,
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
                  obscureText: true,
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print("o cliente é $cliente");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TecnicosListScreen()));
                    }
                  },
                  child: const Text(
                    'Criar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
