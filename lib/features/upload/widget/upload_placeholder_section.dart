import 'package:flutter/material.dart';

class UploadPlaceholderSection extends StatelessWidget {
  const UploadPlaceholderSection({
    super.key,
    required this.cameraSelected,
    required this.gallerySelected,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.height,
  });

  final bool cameraSelected;
  final bool gallerySelected;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: _UploadOptionCard(
              label: cameraSelected ? '사진 업로드 완료' : '카메라 촬영',
              icon: Icons.camera_alt_rounded,
              isSelected: cameraSelected,
              onTap: onCameraTap,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _UploadOptionCard(
              label: gallerySelected ? '사진 업로드 완료' : '내 사진 업로드',
              icon: Icons.photo_library_rounded,
              isSelected: gallerySelected,
              onTap: onGalleryTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadOptionCard extends StatelessWidget {
  const _UploadOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF343356) : const Color(0xFF292842),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9D4D) : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 34),
            const SizedBox(height: 18),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
