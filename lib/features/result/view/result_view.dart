import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/result/model/result_item.dart';
import 'package:fit_mate_client/features/result/viewmodel/result_viewmodel.dart';
import 'package:fit_mate_client/features/result/widget/result_category_chips.dart';
import 'package:fit_mate_client/features/result/widget/result_header.dart';
import 'package:fit_mate_client/features/result/widget/result_item_card.dart';
import 'package:fit_mate_client/features/result/widget/result_preview_card.dart';

const _mockItems = [
  ResultItem(
    id: '1',
    name: '플로럴 미디 랩 드레스',
    brand: 'H&M',
    price: 49900,
    imageUrl: '',
    clothingType: ClothingType.top,
  ),
  ResultItem(
    id: '2',
    name: '화이트 캔버스 스니커즈',
    brand: '나이키',
    price: 79000,
    imageUrl: '',
    clothingType: ClothingType.shoes,
  ),
  ResultItem(
    id: '3',
    name: '미니 크로스백',
    brand: '무신사',
    price: 39900,
    imageUrl: '',
    clothingType: ClothingType.accessory,
  ),
];

class ResultView extends StatefulWidget {
  const ResultView({
    super.key,
    this.generatedImageUrl = '',
    this.items = _mockItems,
  });

  final String generatedImageUrl;
  final List<ResultItem> items;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late final ResultViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ResultViewModel(items: widget.items);
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
                  child: ResultHeader(onRegenerate: () {}),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ResultPreviewCard(
                      generatedImageUrl: widget.generatedImageUrl,
                      onRegenerate: () {},
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildTabs()),
                SliverToBoxAdapter(
                  child: ResultCategoryChips(
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

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          _Tab(
            label: '✓  착용 아이템',
            isSelected: _viewModel.selectedTab == ResultTab.wearingItems,
            onTap: () => _viewModel.selectTab(ResultTab.wearingItems),
          ),
          _Tab(
            label: '✨  추천 카테고리',
            isSelected: _viewModel.selectedTab == ResultTab.recommendations,
            onTap: () => _viewModel.selectTab(ResultTab.recommendations),
          ),
        ],
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
        childAspectRatio: 0.72,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return ResultItemCard(
            item: item,
            isHighlighted: _viewModel.isItemSelected(item.id),
            onTap: () => _viewModel.toggleItem(item.id),
          );
        },
        childCount: items.length,
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? ColorConstants.coral : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? ColorConstants.coral : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}
