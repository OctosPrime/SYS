// Importação necessária para File
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as p;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/foundation.dart';

Future<drive.DriveApi> getDriveApi() async {
  var client =
      await clientViaServiceAccount(ServiceAccountCredentials.fromJson(r'''
  {
    "type": "service_account",
    "project_id": "smart-poet-442120-c5",
    "private_key_id": "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",
    "private_key": "OGClient",
    "client_email": "kayky3232@gmail.com",
    "client_id": "498315476441-nk749bv6o9puj9hih1libjk7hb9oe9eo.apps.googleusercontent.com",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs"
  }
  '''), [drive.DriveApi.driveFileScope]);
  return drive.DriveApi(client);
}

Future<String> createFolder(drive.DriveApi driveApi, String folderName,
    [String? parentFolderId]) async {
  var folder = drive.File();
  folder.name = folderName;
  folder.mimeType = 'application/vnd.google-apps.folder';
  if (parentFolderId != null) {
    folder.parents = [parentFolderId];
  }
  var result = await driveApi.files.create(folder);
  return result.id!;
}

Future<void> uploadFile(
    drive.DriveApi driveApi, String folderId, var file) async {
  late drive.Media media;

  // Para Web, `file` pode ser um objeto File ou Blob. Vamos usar o `file.bytes` se for Web.
  if (kIsWeb) {
    // Para Web, você pode acessar os bytes diretamente do arquivo selecionado
    var fileBytes = file.bytes;
    media = drive.Media(
      Stream.fromIterable([fileBytes]), // Converte os bytes em Stream
      fileBytes.length,
    );
  } else {
    // Para dispositivos móveis e desktop, usamos o arquivo normalmente
    media = drive.Media(file.openRead(), file.lengthSync());
  }

  var driveFile = drive.File();
  driveFile.name = p.basename(file.path); // Usando o nome do arquivo
  driveFile.parents = [folderId]; // Pasta de destino

  // Envia o arquivo para o Google Drive
  await driveApi.files.create(driveFile, uploadMedia: media);
}
