import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fit_mate_client/core/network/api_client.dart';
import 'package:fit_mate_client/features/upload/model/upload_photo.dart';

enum UploadSource { camera, gallery }

enum UploadStatus { idle, picking, uploading, ready, error }

class UploadViewModel extends ChangeNotifier {
  UploadViewModel({ApiClient? apiClient, ImagePicker? picker})
      : _apiClient = apiClient ?? ApiClient(),
        _picker = picker ?? ImagePicker();

  final ApiClient _apiClient;
  final ImagePicker _picker;

  UploadPhoto? _photo;
  UploadSource? _selectedSource;
  UploadStatus _status = UploadStatus.idle;
  String? _errorMessage;

  UploadPhoto? get photo => _photo;
  UploadSource? get selectedSource => _selectedSource;
  UploadStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasPhoto => _photo != null && _status == UploadStatus.ready;

  Future<void> selectSource(UploadSource source) async {
    _selectedSource = source;
    _status = UploadStatus.picking;
    _errorMessage = null;
    notifyListeners();

    final picked = await _picker.pickImage(
      source: source == UploadSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
    );
    if (picked == null) {
      _status = _photo == null ? UploadStatus.idle : UploadStatus.ready;
      notifyListeners();
      return;
    }

    _status = UploadStatus.uploading;
    notifyListeners();

    try {
      final bytes = await picked.readAsBytes();
      debugPrint('[UploadViewModel] uploading name=${picked.name} size=${bytes.lengthInBytes}');
      final response = await _apiClient.postMultipartFile(
        '/user/image',
        field: 'image',
        file: picked,
      );
      debugPrint('[UploadViewModel] upload response=$response');
      final filename = (response as Map<String, dynamic>)['filename'] as String;
      _photo = UploadPhoto(
        bytes: bytes,
        fileName: picked.name,
        userImageName: filename,
      );
      _status = UploadStatus.ready;
    } catch (e, st) {
      debugPrint('[UploadViewModel] upload failed: $e\n$st');
      _photo = null;
      _errorMessage = '사진 업로드에 실패했습니다.';
      _status = UploadStatus.error;
    }
    notifyListeners();
  }
}
