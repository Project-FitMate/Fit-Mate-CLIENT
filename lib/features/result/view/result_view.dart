import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fit_mate_client/features/result/model/result_item.dart';
import 'package:fit_mate_client/features/result/viewmodel/result_viewmodel.dart';
import 'package:fit_mate_client/features/result/widget/result_category_chips.dart';
import 'package:fit_mate_client/features/result/widget/result_header.dart';
import 'package:fit_mate_client/features/result/widget/result_item_card.dart';
import 'package:fit_mate_client/features/result/widget/result_preview_card.dart';
import 'package:fit_mate_client/shared/widgets/zoomable_image_view.dart';

class ResultView extends StatefulWidget {
  const ResultView({
    super.key,
    this.generatedImageBase64 = '',
    this.items = const <ResultItem>[],
  });

  final String generatedImageBase64;
  final List<ResultItem> items;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late final ResultViewModel _viewModel;
  Uint8List? _decodedImage;

  @override
  void initState() {
    super.initState();
    _viewModel = ResultViewModel(items: widget.items);
    if (widget.generatedImageBase64.isNotEmpty) {
      try {
        _decodedImage = base64Decode(widget.generatedImageBase64);
      } catch (_) {
        _decodedImage = null;
      }
    }
  }

  void _openZoom() {
    if (_decodedImage == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ZoomableImageView(imageBytes: _decodedImage!),
      ),
    );
  }

  // Open the product page in the external browser / shopping app.
  Future<void> _openProduct(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || url.isEmpty) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('링크를 열 수 없습니다.')),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ResultHeader(
                    onRegenerate: () => Navigator.of(context).maybePop(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ResultPreviewCard(
                      generatedImage: _decodedImage,
                      onRegenerate: () => Navigator.of(context).maybePop(),
                      onTapImage: _openZoom,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ResultCategoryChips(
                    availableParts: _viewModel.availableParts,
                    selectedCategory: _viewModel.selectedCategory,
                    onSelect: _viewModel.selectCategory,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  sliver: _buildItemGrid(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemGrid() {
    final items = _viewModel.filteredItems;

    if (items.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              '해당 카테고리 아이템이 없습니다',
              style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
            ),
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.62,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return ResultItemCard(
            item: item,
            isHighlighted: _viewModel.isItemSelected(item.id),
            onTap: () => _viewModel.toggleItem(item.id),
            onOpenLink: item.productUrl.isEmpty
                ? null
                : () => _openProduct(item.productUrl),
          );
        },
        childCount: items.length,
      ),
    );
  }
}

