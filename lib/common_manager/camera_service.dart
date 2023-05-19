import 'dart:io';

import 'package:epms/screen/camera/camera_screen.dart';
import 'package:flutter/material.dart';

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
}
