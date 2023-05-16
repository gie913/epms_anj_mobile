import 'dart:io';

class DeleteImageService {
  deleteImage(String path) async {
    bool isExist = await File(path).exists();
    if (isExist) {
      await File(path).delete();
    }
  }
}
