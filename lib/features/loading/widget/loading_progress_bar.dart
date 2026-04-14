import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';

class LoadingProgressBar extends StatelessWidget {
  const LoadingProgressBar({super.key, required this.progressAnim});

  final Animation<double> progressAnim;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressAnim,
      builder: (context, _) {
        return SizedBox(
          height: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final filledWidth = totalWidth * progressAnim.value;
              return Stack(
                children: [
                  // Track
                  Container(color: const Color(0xFFF1F5F9)),
                  // Filled bar with glow
                  Container(
                    width: filledWidth,
                    decoration: BoxDecoration(
                      color: ColorConstants.coral,
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstants.coral.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  // Glowing tip
                  if (filledWidth > 24)
                    Positioned(
                      left: filledWidth - 24,
                      top: 0,
                      bottom: 0,
                      width: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
