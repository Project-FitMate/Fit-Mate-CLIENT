import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/view/recommendation_view.dart';
import 'package:fit_mate_client/features/styling_condition/viewmodel/styling_condition_viewmodel.dart';
import 'package:fit_mate_client/features/styling_condition/widget/condition_filter_chip.dart';
import 'package:fit_mate_client/features/styling_condition/widget/price_range_section.dart';
import 'package:fit_mate_client/features/styling_condition/widget/upload_status_card.dart';
import 'package:fit_mate_client/features/upload/model/upload_photo.dart';
import 'package:fit_mate_client/features/upload/viewmodel/upload_viewmodel.dart';
import 'package:fit_mate_client/shared/widgets/primary_action_button.dart';

class StylingConditionView extends StatefulWidget {
  const StylingConditionView({super.key, required this.photo});

  final UploadPhoto photo;

  @override
  State<StylingConditionView> createState() => _StylingConditionViewState();
}

class _StylingConditionViewState extends State<StylingConditionView> {
  late final StylingConditionViewModel _viewModel;
  late final UploadViewModel _uploadVm;
  late UploadPhoto _photo;

  @override
  void initState() {
    super.initState();
    _viewModel = StylingConditionViewModel();
    _uploadVm = UploadViewModel();
    _photo = widget.photo;
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _uploadVm.dispose();
    super.dispose();
  }

  // Re-pick + re-upload a photo, then swap it (and its userImageName) in place.
  Future<void> _changePhoto() async {
    final source = await showModalBottomSheet<UploadSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('카메라로 촬영'),
              onTap: () => Navigator.pop(ctx, UploadSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('갤러리에서 선택'),
              onTap: () => Navigator.pop(ctx, UploadSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    await _uploadVm.selectSource(source);
    if (!mounted) return;
    final photo = _uploadVm.photo;
    if (_uploadVm.hasPhoto && photo != null) {
      setState(() => _photo = photo);
    } else if (_uploadVm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_uploadVm.errorMessage!)),
      );
    }
  }

  void _goToRecommendation() {
    final c = _viewModel.condition;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecommendationView(
          parts: c.categories.toList(),
          minPrice: c.minPrice,
          maxPrice: c.maxPrice,
          userImageName: _photo.userImageName,
          uploadedImage: _photo.bytes,
          sortOption: c.sortOption,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
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
              UploadStatusCard(
                photoBytes: _photo.bytes,
                onChangePhoto: _changePhoto,
              ),
              const SizedBox(height: 16),
              _SectionCard(
                icon: Icons.checkroom_rounded,
                label: '착용 부위 선택',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      StylingConditionViewModel.categoryOptions.map((category) {
                    final icons = {
                      '전신': '🧍',
                      '상의': '👕',
                      '하의': '👖',
                      '아우터': '🧥',
                      '원피스': '👗',
                      '신발': '👟',
                      '모자': '🧢',
                    };

                    return ConditionFilterChip(
                      label: category,
                      icon: icons[category],
                      isSelected: condition.categories
                          .contains(OutfitPart.fromLabel(category)),
                      onTap: () => _viewModel.selectCategory(category),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                icon: Icons.attach_money_rounded,
                label: '가격 범위',
                child: PriceRangeSection(
                  minPrice: condition.minPrice,
                  maxPrice: condition.maxPrice,
                  minAllowedPrice: StylingConditionViewModel.minAllowedPrice,
                  maxAllowedPrice: _viewModel.maxAllowedPrice,
                  onChanged: (values) {
                    _viewModel.updatePriceRange(
                      start: values.start,
                      end: values.end,
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Sort selection is a client-side display preference only;
              // it is intentionally not sent to the server.
              _SectionCard(
                icon: Icons.bar_chart_rounded,
                label: '정렬 기준',
                child: Wrap(
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
              ),
              const SizedBox(height: 28),
              PrimaryActionButton(
                label: '스타일 추천받기',
                icon: Icons.auto_awesome_rounded,
                onPressed:
                    condition.categories.isEmpty ? null : _goToRecommendation,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEFF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A101828),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(icon: icon, label: label),
          const SizedBox(height: 12),
          child,
        ],
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
        Icon(icon, size: 22, color: const Color(0xFF6C6F7B)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF22252D),
          ),
        ),
      ],
    );
  }
}
