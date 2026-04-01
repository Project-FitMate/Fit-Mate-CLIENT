import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/styling_condition/viewmodel/styling_condition_viewmodel.dart';
import 'package:fit_mate_client/features/styling_condition/widget/condition_filter_chip.dart';
import 'package:fit_mate_client/features/styling_condition/widget/price_range_section.dart';
import 'package:fit_mate_client/features/styling_condition/widget/upload_status_card.dart';
import 'package:fit_mate_client/shared/widgets/primary_action_button.dart';

class StylingConditionView extends StatefulWidget {
  const StylingConditionView({super.key});

  @override
  State<StylingConditionView> createState() => _StylingConditionViewState();
}

class _StylingConditionViewState extends State<StylingConditionView> {
  late final StylingConditionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = StylingConditionViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '착용 조건 설정',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton(
            onPressed: _viewModel.reset,
            child: const Text(
              '초기화',
              style: TextStyle(
                color: Color(0xFFFF617E),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          final condition = _viewModel.condition;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              const UploadStatusCard(),
              const SizedBox(height: 20),
              const _SectionTitle(
                icon: Icons.search_rounded,
                label: '제품 검색',
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: '브랜드, 제품명으로 검색...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE8EAF2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE8EAF2)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _SectionTitle(
                icon: Icons.checkroom_rounded,
                label: '착용 부위 선택',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: StylingConditionViewModel.categoryOptions.map((category) {
                  final icons = {
                    '전신': '🧍',
                    '상의': '👕',
                    '하의': '👖',
                    '아우터': '🧥',
                    '원피스': '👗',
                    '신발': '👟',
                  };

                  return ConditionFilterChip(
                    label: category,
                    icon: icons[category],
                    isSelected: condition.category == category,
                    onTap: () => _viewModel.selectCategory(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const _SectionTitle(
                icon: Icons.attach_money_rounded,
                label: '가격 범위',
              ),
              const SizedBox(height: 12),
              PriceRangeSection(
                selectedRange: condition.priceRangeLabel,
                onRangeTap: _viewModel.selectPriceRange,
              ),
              const SizedBox(height: 24),
              const _SectionTitle(
                icon: Icons.bar_chart_rounded,
                label: '정렬 기준',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: StylingConditionViewModel.sortOptions
                    .map(
                      (sortOption) => ConditionFilterChip(
                        label: sortOption,
                        isSelected: condition.sortOption == sortOption,
                        onTap: () => _viewModel.selectSortOption(sortOption),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 28),
              PrimaryActionButton(
                label: '스타일 추천받기',
                icon: Icons.auto_awesome_rounded,
                onPressed: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6C6F7B)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF22252D),
          ),
        ),
      ],
    );
  }
}
