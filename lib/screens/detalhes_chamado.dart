//import 'package:web/web.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path; // Importação do pacote path
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart'; // Para formatação de datas
import 'package:sys/cloud/googledrive.dart';
import 'package:sys/screens/lista_chamados.dart';
import 'package:sys/screens/edit_chamado.dart';

class ChamadoDetailScreen extends StatefulWidget {
  final ChamadoCriado chamado;

  ChamadoDetailScreen({required this.chamado});

  @override
  _ChamadoDetailScreenState createState() => _ChamadoDetailScreenState();
}

class _ChamadoDetailScreenState extends State<ChamadoDetailScreen> {
  late String _buttonText;
  late Color _buttonColor;
  List<File> _filesToUpload = [];

  @override
  void initState() {
    super.initState();
    _setInitialButtonState();
  }

  void _setInitialButtonState() {
    if (widget.chamado.status == 'Aberto') {
      _buttonText = 'Iniciar';
      _buttonColor = Colors.yellow;
    } else if (widget.chamado.status == 'Em Andamento') {
      _buttonText = 'Finalizar';
      _buttonColor = Colors.blue;
    } else {
      _buttonText = 'Indisponível';
      _buttonColor = Colors.grey;
    }
  }

  void _updateChamadoStatus(String status) {
    setState(() {
      widget.chamado.status = status;
      _setInitialButtonState();
      // Atualize o banco de dados aqui, caso necessário
    });
  }

  void _onButtonPressed() {
    if (_buttonText == 'Iniciar') {
      _updateChamadoStatus('Em Andamento');
    } else if (_buttonText == 'Finalizar') {
      _showFinalizarChamadoDialog();
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          // Para Web, você usa os bytes diretamente
          _filesToUpload = result.files
              .map((file) => file.bytes != null
                  ? File.fromRawPath(file.bytes!) // Converte os bytes para File
                  : throw Exception("Arquivo inválido"))
              .toList();
        } else {
          // Para dispositivos móveis, o caminho do arquivo é válido
          _filesToUpload = result.paths.map((path) => File(path!)).toList();
        }
      });
    }
  }

  Future<void> _uploadFiles() async {
    var driveApi = await getDriveApi();

    // Certifique-se de que o código não está tentando criar uma conexão de rede no Flutter Web
    if (!kIsWeb) {
      // Criar pasta "bk_os" se não existir
      String bkOsFolderId = await createFolder(driveApi, 'bk_os');
      // Criar pasta específica para o chamado
      String specificFolderName =
          '${widget.chamado.cliente}_${widget.chamado.chamado}';
      String specificFolderId =
          await createFolder(driveApi, specificFolderName, bkOsFolderId);

      // Fazer upload dos arquivos para a pasta específica
      for (var file in _filesToUpload) {
        await uploadFile(driveApi, specificFolderId, file);
      }
    } else {
      print('Operações de upload não são suportadas no Web.');
    }
  }

  void _showFinalizarChamadoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController observacoesController =
            TextEditingController(text: widget.chamado.observacao);
        String statusSelecionado = 'Em Andamento';
        DateTime dataConclusao = DateTime.now();
        return AlertDialog(
          title: Text('Finalizar Chamado'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailCard('Técnico', widget.chamado.tecnico),
                _buildDetailCard('Chamado', widget.chamado.chamado),
                _buildDetailCard('Cliente', widget.chamado.cliente),
                _buildDetailCard('Equipamento', widget.chamado.equipamento),
                _buildDetailCard(
                    'Data/Hora Agendada', widget.chamado.dataHora.toString()),
                _buildDetailCard('Link do Mapa', widget.chamado.link,
                    isLink: true),
                TextField(
                  controller: observacoesController,
                  decoration: InputDecoration(
                    labelText: 'Observações',
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: statusSelecionado,
                  items: ['Em Andamento', 'Finalizar']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        statusSelecionado = value;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Status da Ordem de Serviço',
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Data de Conclusão da OS',
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(dataConclusao),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: dataConclusao,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        dataConclusao = picked;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickFiles,
                  child: Text('Escolher Arquivos'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _uploadFiles,
                  child: Text('Enviar Arquivos para Google Drive'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateChamadoStatus('Finalizado');
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Chamado'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailCard('Chamado', widget.chamado.chamado),
                  _buildDetailCard('Cliente', widget.chamado.cliente),
                  _buildDetailCard('Equipamento', widget.chamado.equipamento),
                  _buildDetailCard(
                      'Data/Hora', widget.chamado.dataHora.toString()),
                  _buildDetailCard('Endereço', widget.chamado.endereco),
                  _buildDetailCard('Celular', widget.chamado.celular),
                  _buildDetailCard('Link Maps', widget.chamado.link,
                      isLink: true),
                  _buildDetailCard('Observação', widget.chamado.observacao),
                  _buildDetailCard('Técnico', widget.chamado.tecnico),
                  _buildDetailCard('Status', widget.chamado.status),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () async {
              bool? shouldRefresh = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditarChamadoScreen(chamado: widget.chamado),
                ),
              );
              if (shouldRefresh == true) {
                Navigator.pop(context, true);
              }
            },
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            child: Text(_buttonText),
            backgroundColor: _buttonColor,
            onPressed: _buttonText == 'Indisponível' ? null : _onButtonPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, {bool isLink = false}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.0),
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
            Flexible(
              child: isLink
                  ? GestureDetector(
                      onTap: () {
                        // Implement link action here
                      },
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    )
                  : Text(
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

  Future<drive.DriveApi> getDriveApi() async {
    var client = await clientViaUserConsent(
        ClientId('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET'),
        [drive.DriveApi.driveFileScope], (url) {
      print('Por favor, vá para o seguinte URL e conceda acesso:');
      print(' => $url');
    });
    return drive.DriveApi(client);
  }

  Future<void> uploadFile(
      drive.DriveApi driveApi, String folderId, File file) async {
    var media = drive.Media(file.openRead(), file.lengthSync());
    var driveFile = drive.File()
      ..name = path.basename(file.path)
      ..parents = [folderId];
    await driveApi.files.create(driveFile, uploadMedia: media);
  }
}
