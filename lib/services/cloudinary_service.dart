import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class CloudinaryService {
  Future<String?> subirImagen(File? imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/paca/image/upload?upload_preset=bjpckkvm');

    final mimeType = mime(imagen?.path)!.split('/');

    ///image/jpg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );

    imageUploadRequest.fields['folder'] = 'Proyecto-Garcia';

    final file = await http.MultipartFile.fromPath('file', imagen!.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final stringResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(stringResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    print(respData['secure_url']);

    return respData['secure_url'];
  }
}
