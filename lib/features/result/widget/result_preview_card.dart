import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

class ResultPreviewCard extends StatelessWidget {
  const ResultPreviewCard({
    super.key,
    required this.generatedImage,
    required this.onRegenerate,
    this.onTapImage,
  });

  final Uint8List? generatedImage;
  final VoidCallback onRegenerate;
  final VoidCallback? onTapImage;

  Future<void> _save(BuildContext context) async {
    final image = generatedImage;
    if (image == null) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await Gal.putImageBytes(image, name: 'fitmate_${DateTime.now().millisecondsSinceEpoch}');
      messenger.showSnackBar(
        const SnackBar(content: Text('사진 앨범에 저장했습니다.')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('이미지 저장에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 256,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3E8FF), Color(0xFFD1D5FF)],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Center(
            child: generatedImage != null
                ? GestureDetector(
                    onTap: onTapImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.memory(
                        generatedImage!,
                        fit: BoxFit.contain,
                        height: 240,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person_outline_rounded,
                    size: 80,
                    color: Color(0xFFBDBDBD),
                  ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: Color(0xFFFF7E5F)),
                  SizedBox(width: 4),
                  Text(
                    'AI 생성 이미지',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (generatedImage != null) ...[
            Positioned(
              bottom: 16,
              left: 16,
              child: _CircleIconButton(
                icon: Icons.zoom_in_rounded,
                tooltip: '확대',
                onTap: () => onTapImage?.call(),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: _CircleIconButton(
                icon: Icons.download_rounded,
                tooltip: '다운로드',
                onTap: () => _save(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

