import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/upload/model/upload_photo.dart';

enum UploadSource {
  camera,
  gallery,
}

class UploadViewModel extends ChangeNotifier {
  UploadPhoto? _photo;
  UploadSource? _selectedSource;

  UploadPhoto? get photo => _photo;
  UploadSource? get selectedSource => _selectedSource;

  bool get hasPhoto => _photo != null;

  void selectSource(UploadSource source) {
    _selectedSource = source;
    _photo = UploadPhoto(
      fileName: source == UploadSource.camera
          ? 'camera_photo.png'
          : 'gallery_photo.png',
      localPath: source == UploadSource.camera
          ? '/mock/camera_photo.png'
          : '/mock/gallery_photo.png',
    );
    notifyListeners();
  }
}
