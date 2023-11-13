import 'dart:io';

import 'package:epms/screen/camera/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Image;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  static Future<String?> getImageByCamera(BuildContext context) async {
    File? xFile = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraScreen()));
    if (xFile != null) {
      return xFile.path.toString();
    }
    return null;
    // ImagePicker _picker = ImagePicker();
    // try {
    //   XFile? pickedFile = await _picker.pickImage(
    //     source: ImageSource.camera,
    //     imageQuality: 25,
    //     maxHeight: 800,
    //     preferredCameraDevice: CameraDevice.rear,
    //     maxWidth: 600
    //   );
    //   if (pickedFile != null) {
    //     // final now = DateTime.now();
    //     // List<String> list = ValueService.generateIDImageFromDateTime(now);
    //     // for(int i = 1; i < list.length; i++) {
    //     //   final dir = File("storage/emulated/0/DCIM/Camera/IMG_${list[i]}.jpg");
    //     //   dir.delete(recursive: true);
    //     // }
    //     return pickedFile.path;
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  static Future<String?> getImage(
    BuildContext context, {
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    String? imagePath;
    if (imageSource == ImageSource.gallery) {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        File fileTemp = File(pickedImage.path);
        Image.Image? image = decodeImage(fileTemp.readAsBytesSync());
        Image.Image? resizedImage = copyResize(image!, width: 600, height: 800);
        Directory tempDir = await getTemporaryDirectory();
        File fileResult = File('${tempDir.path}/${pickedImage.name}')
          ..writeAsBytesSync(encodeJpg(resizedImage, quality: 70));

        imagePath = fileResult.path.toString();
      }
      return imagePath;
    } else {
      File? xFile = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CameraScreen()));
      if (xFile != null) {
        imagePath = xFile.path.toString();
      }
      return imagePath;
    }
  }
}
