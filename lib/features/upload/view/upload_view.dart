import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/upload/viewmodel/upload_viewmodel.dart';
import 'package:fit_mate_client/features/upload/widget/upload_placeholder_section.dart';
import 'package:fit_mate_client/shared/widgets/primary_action_button.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  late final UploadViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = UploadViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1D39), Color(0xFF17162F)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final uploadHeight =
                  (constraints.maxHeight * 0.34).clamp(220.0, 320.0);
              final bottomSpacing =
                  (constraints.maxHeight * 0.24).clamp(56.0, 150.0);

              return AnimatedBuilder(
                animation: _viewModel,
                builder: (context, _) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6D6D), Color(0xFFFFA726)],
                              ),
                            ),
                            child: const Icon(
                              Icons.checkroom_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              '핏메이트',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        '안녕하세요',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '오늘은 어떤 스타일을\n시도해볼까요?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 28),
                      UploadPlaceholderSection(
                        cameraSelected:
                            _viewModel.selectedSource == UploadSource.camera,
                        gallerySelected:
                            _viewModel.selectedSource == UploadSource.gallery,
                        onCameraTap: () {
                          _viewModel.selectSource(UploadSource.camera);
                        },
                        onGalleryTap: () {
                          _viewModel.selectSource(UploadSource.gallery);
                        },
                        height: uploadHeight,
                      ),
                      SizedBox(height: bottomSpacing),
                      PrimaryActionButton(
                        label: '사진 분석하기',
                        icon: Icons.auto_awesome_rounded,
                        onPressed: _viewModel.hasPhoto ? () {} : null,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
