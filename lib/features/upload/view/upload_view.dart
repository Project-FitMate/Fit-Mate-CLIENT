import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/upload/widget/upload_placeholder_section.dart';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: UploadPlaceholderSection(),
      ),
    );
  }
}
