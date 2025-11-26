import 'package:image_picker/image_picker.dart';

class Fotografia {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> tomarFoto() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (foto == null) return null;

    return foto.path;
  }
}