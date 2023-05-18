import 'package:image_picker/image_picker.dart';

class CameraService {
  static Future<String?> getImageByCamera() async {
    ImagePicker _picker = ImagePicker();
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        return pickedFile.path;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
