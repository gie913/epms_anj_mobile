import 'dart:convert';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/delete_image_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class UploadImageOPHRepository extends APIConfiguration {
  void doUploadPhoto(BuildContext context, String image, String moduleId,
      String module, onSuccess, onError) async {
    String token = await StorageManager.readData("userToken");
    String baseUrl = await StorageManager.readData("apiServer");

    File imageFile = File(image);
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    try {
      var url = baseUrl + APIEndPoint.UPLOAD_IMAGE;
      var uri = Uri.parse(url);
      var request = http.MultipartRequest("POST", uri);
      var mimeContent = lookupMimeType(
          '${imageFile.path.toString().substring(imageFile.path.toString().length - 20)}');
      var typeMedia = mimeContent!.substring(0, mimeContent.indexOf('/', 0));
      var pos = mimeContent.indexOf('/', 0);
      var subTypeMedia = mimeContent.substring(pos + 1, mimeContent.length);
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path),
          contentType: MediaType(typeMedia, subTypeMedia));
      request.files.add(multipartFile);
      request.fields['module_id'] = moduleId;
      request.fields['module'] = module;
      request.fields['name'] = "image";
      request.fields['user_token'] = token;
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        if (response.statusCode == 200) {
          onSuccess(context, response);
          DeleteImageService().deleteImage(imageFile.path);
        } else {
          onError(context, response.toString());
        }
      });
    } on SocketException {
      onError(context, 'No Internet');
    } on HttpException {
      onError(context, 'No Service Found');
    } on FormatException {
      onError(context, 'Invalid Response format');
    } catch (exception) {
      onError(context, exception.toString());
    }
  }
}
