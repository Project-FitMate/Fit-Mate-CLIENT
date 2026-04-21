import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';

const _frameWidth = 288.0;
const _frameHeight = 450.0;

class LoadingScanFrame extends StatelessWidget {
  const LoadingScanFrame({
    super.key,
    required this.scanPositionAnim,
    required this.scanOpacityAnim,
    required this.pulseOpacityAnim,
    required this.fillAnim,
  });

  final Animation<double> scanPositionAnim;
  final Animation<double> scanOpacityAnim;
  final Animation<double> pulseOpacityAnim;
  final Animation<double> fillAnim;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: _frameWidth,
        height: _frameHeight,
        child: Stack(
          children: [
            // Background frame
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Corner accents
            ..._buildCorners(),
            // Character silhouette
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([pulseOpacityAnim, fillAnim]),
                builder: (context, _) => Opacity(
                  opacity: pulseOpacityAnim.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Gray base
                      const Icon(
                        Icons.accessibility_new,
                        size: 192,
                        color: Color(0xFFCBD5E1),
                      ),
                      // Coral fill — revealed top → bottom
                      ClipRect(
                        clipper: _TopFillClipper(fillRatio: fillAnim.value),
                        child: const Icon(
                          Icons.accessibility_new,
                          size: 192,
                          color: ColorConstants.coral,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Scan line
            AnimatedBuilder(
              animation: Listenable.merge([scanPositionAnim, scanOpacityAnim]),
              builder: (context, _) {
                final top = scanPositionAnim.value * (_frameHeight - 4);
                return Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  height: 4,
                  child: Opacity(
                    opacity: scanOpacityAnim.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            ColorConstants.coral,
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.coral.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const pad = 16.0;
    const size = 16.0;
    return [
      Positioned(top: pad, left: pad, child: const _Corner(top: true, left: true, size: size)),
      Positioned(top: pad, right: pad, child: const _Corner(top: true, left: false, size: size)),
      Positioned(bottom: pad, left: pad, child: const _Corner(top: false, left: true, size: size)),
      Positioned(bottom: pad, right: pad, child: const _Corner(top: false, left: false, size: size)),
    ];
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.top, required this.left, required this.size});

  final bool top;
  final bool left;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CornerPainter(top: top, left: left)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({required this.top, required this.left});

  final bool top;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopFillClipper extends CustomClipper<Rect> {
  _TopFillClipper({required this.fillRatio});

  final double fillRatio;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height * fillRatio);
  }

  @override
  bool shouldReclip(_TopFillClipper old) => old.fillRatio != fillRatio;
}
