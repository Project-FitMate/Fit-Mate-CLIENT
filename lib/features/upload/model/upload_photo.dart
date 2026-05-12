import 'dart:io';

class UploadPhoto {
  const UploadPhoto({
    required this.file,
    required this.userImageName,
  });

  final File file;
  // Returned by the server's POST /user/image (response.filename).
  // Used as `userImageName` for /outfit and /fitting calls.
  final String userImageName;
}
