import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';
import 'package:fit_mate_client/features/result/view/result_view.dart';
import 'package:fit_mate_client/features/saved/model/saved_fitting.dart';
import 'package:fit_mate_client/features/saved/repository/saved_fitting_store.dart';
import 'package:fit_mate_client/features/styling_condition/view/styling_condition_view.dart';
import 'package:fit_mate_client/features/upload/viewmodel/upload_viewmodel.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  final _store = SavedFittingStore();
  final _uploadVm = UploadViewModel();
  late Future<List<SavedFitting>> _future;

  @override
  void initState() {
    super.initState();
    _future = _store.list();
  }

  @override
  void dispose() {
    _uploadVm.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = _store.list();
    });
  }

  // Bottom camera button: capture, upload, then enter the styling flow.
  Future<void> _captureAndProceed() async {
    await _uploadVm.selectSource(UploadSource.camera);
    if (!mounted) return;
    final photo = _uploadVm.photo;
    if (_uploadVm.hasPhoto && photo != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => StylingConditionView(photo: photo)),
      );
      _reload();
    }
  }

  Future<void> _open(SavedFitting fitting) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultView(
          generatedImageBase64: fitting.imageBase64,
          items: fitting.items,
        ),
      ),
    );
    _reload();
  }

  Future<void> _delete(SavedFitting fitting) async {
    await _store.delete(fitting.id);
    _reload();
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}.${two(d.month)}.${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }

  Widget _buildCameraBar() {
    return AnimatedBuilder(
      animation: _uploadVm,
      builder: (context, _) {
        final isBusy = _uploadVm.status == UploadStatus.uploading ||
            _uploadVm.status == UploadStatus.picking;
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: GestureDetector(
              onTap: isBusy ? null : _captureAndProceed,
              child: Opacity(
                opacity: isBusy ? 0.6 : 1,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6D6D), Color(0xFFFFA726)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        isBusy ? '업로드 중...' : '새 피팅 시작',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '내 피팅',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      bottomNavigationBar: _buildCameraBar(),
      body: FutureBuilder<List<SavedFitting>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ColorConstants.coral),
            );
          }
          final items = snapshot.data ?? const <SavedFitting>[];
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library_outlined,
                      size: 64, color: Color(0xFFCDD2DA)),
                  SizedBox(height: 16),
                  Text(
                    '저장된 피팅이 없습니다',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _SavedCard(
              fitting: items[index],
              dateLabel: _formatDate(items[index].createdAt),
              onTap: () => _open(items[index]),
              onDelete: () => _delete(items[index]),
            ),
          );
        },
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({
    required this.fitting,
    required this.dateLabel,
    required this.onTap,
    required this.onDelete,
  });

  final SavedFitting fitting;
  final String dateLabel;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;
    try {
      bytes = base64Decode(fitting.imageBase64);
    } catch (_) {
      bytes = null;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDEFF5)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  bytes != null
                      ? Image.memory(bytes, fit: BoxFit.cover)
                      : const ColoredBox(
                          color: Color(0xFFEFF1F6),
                          child: Icon(Icons.broken_image_outlined,
                              color: Color(0xFFBFC5D2)),
                        ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF22252D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '착용 ${fitting.items.length}개',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
