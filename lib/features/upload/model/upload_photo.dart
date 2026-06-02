import 'dart:typed_data';

class UploadPhoto {
  const UploadPhoto({
    required this.bytes,
    required this.fileName,
    required this.userImageName,
  });

  final Uint8List bytes;
  final String fileName;
  // Returned by the server's POST /user/image (response.filename).
  // Used as `userImageName` for /outfit and /fitting calls.
  final String userImageName;
}
