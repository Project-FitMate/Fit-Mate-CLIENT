import 'package:flutter/material.dart';

class UploadPlaceholderSection extends StatelessWidget {
  const UploadPlaceholderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Upload feature placeholder'),
      ),
    );
  }
}
