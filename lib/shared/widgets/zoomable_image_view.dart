import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Fullscreen image viewer: drag to pan, pinch or double-tap to zoom.
/// Push with `fullscreenDialog: true`.
class ZoomableImageView extends StatefulWidget {
  const ZoomableImageView({super.key, required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<ZoomableImageView> createState() => _ZoomableImageViewState();
}

class _ZoomableImageViewState extends State<ZoomableImageView>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late final AnimationController _animController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        if (_animation != null) _controller.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Double-tap toggles between fit (1x) and 2.5x centred on the tapped point.
  // Useful where pinch isn't available (e.g. a simulator trackpad).
  void _handleDoubleTap() {
    final isZoomedIn = _controller.value.getMaxScaleOnAxis() > 1.01;
    final position = _doubleTapDetails?.localPosition;
    final Matrix4 end;
    if (isZoomedIn || position == null) {
      end = Matrix4.identity();
    } else {
      const scale = 2.5;
      end = Matrix4.identity()
        ..translateByDouble(
            -position.dx * (scale - 1), -position.dy * (scale - 1), 0, 1)
        ..scaleByDouble(scale, scale, scale, 1);
    }
    _animation = Matrix4Tween(begin: _controller.value, end: end).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onDoubleTapDown: (details) => _doubleTapDetails = details,
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController: _controller,
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 1,
                  maxScale: 6,
                  // Allow free panning once zoomed in.
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  child: Center(
                    child: Image.memory(widget.imageBytes, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
