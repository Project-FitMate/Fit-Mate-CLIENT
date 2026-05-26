import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';
import 'package:fit_mate_client/features/loading/view/loading_view.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/viewmodel/recommendation_viewmodel.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_action_button.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_card.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_header.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_search_bar.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_selection_banner.dart';

class RecommendationView extends StatefulWidget {
  const RecommendationView({
    super.key,
    required this.part,
    required this.minPrice,
    required this.maxPrice,
    required this.userImageName,
    this.uploadedImage,
  });

  final OutfitPart part;
  final int minPrice;
  final int maxPrice;
  final String userImageName;
  final Uint8List? uploadedImage;

  @override
  State<RecommendationView> createState() => _RecommendationViewState();
}

class _RecommendationViewState extends State<RecommendationView> {
  late final RecommendationViewModel _viewModel;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _viewModel = RecommendationViewModel(
      part: widget.part,
      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,
      userImageName: widget.userImageName,
    );
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onProceed() {
    final selected = _viewModel.selectedProduct;
    if (selected == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoadingView(
          userImageName: widget.userImageName,
          outfitImageUrl: selected.imageUrl,
          selectedProduct: selected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return Column(
              children: [
                RecommendationHeader(
                  part: widget.part,
                  uploadedImage: widget.uploadedImage,
                  productCount: _viewModel.products.length,
                ),
                RecommendationSearchBar(
                  controller: _searchController,
                  onChanged: _viewModel.updateSearchQuery,
                ),
                Expanded(
                  child: switch (_viewModel.status) {
                    RecommendationStatus.initial ||
                    RecommendationStatus.loading =>
                      const _LoadingBody(),
                    RecommendationStatus.error => _ErrorBody(
                        message: _viewModel.errorMessage ?? '오류가 발생했습니다.',
                        onRetry: _viewModel.refresh,
                      ),
                    RecommendationStatus.success => _ProductList(
                        viewModel: _viewModel,
                      ),
                  },
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) => RecommendationActionButton(
          selectedCount: _viewModel.selectedCount,
          onPressed: _onProceed,
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.viewModel});

  final RecommendationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final products = viewModel.products;

    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checkroom_outlined, size: 64, color: Color(0xFFCDD2DA)),
            SizedBox(height: 16),
            Text(
              '추천 아이템이 없습니다',
              style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      itemCount: products.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return RecommendationSelectionBanner(
            selectedCount: viewModel.selectedCount,
            onClear: viewModel.clearSelection,
          );
        }
        final product = products[index - 1];
        final isSelected = viewModel.isSelected(product.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RecommendationCard(
            product: product,
            isSelected: isSelected,
            onTap: () => viewModel.toggleSelection(product.id),
          ),
        );
      },
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: ColorConstants.coral),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 56,
            color: Color(0xFFCDD2DA),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: ColorConstants.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              '다시 시도',
              style: TextStyle(color: ColorConstants.coral),
            ),
          ),
        ],
      ),
    );
  }
}
