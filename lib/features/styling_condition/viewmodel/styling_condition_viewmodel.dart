import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/styling_condition/model/styling_condition.dart';

class StylingConditionViewModel extends ChangeNotifier {
  // Display order for the category chips. Korean labels map to OutfitPart via fromLabel().
  static const categoryOptions = ['상의', '하의', '아우터', '원피스', '신발', '모자'];
  // Client-side only sort options; not sent to the server.
  static const sortOptions = ['AI 추천순', '가격 낮은순', '인기순', '신상품'];
  static const minAllowedPrice = 0;
  // Each garment spans 0~500,000; total budget scales with selected parts.
  static const maxPricePerPart = 500000;

  StylingCondition _condition = StylingCondition(
    categories: {OutfitPart.top},
    minPrice: 18000,
    maxPrice: 150000,
    sortOption: 'AI 추천순',
  );

  StylingCondition get condition => _condition;

  // Slider ceiling = 500,000 × (number of selected parts). At least one part
  // worth of range so the slider stays usable when nothing is selected.
  int get maxAllowedPrice {
    final partCount =
        _condition.categories.isEmpty ? 1 : _condition.categories.length;
    return maxPricePerPart * partCount;
  }

  // Multi-selection: tapping a chip toggles the category in/out of the set.
  void selectCategory(String categoryLabel) {
    final part = OutfitPart.fromLabel(categoryLabel);
    final next = Set<OutfitPart>.from(_condition.categories);
    if (next.contains(part)) {
      next.remove(part);
    } else {
      next.add(part);
    }
    _condition = _condition.copyWith(categories: next);
    // Removing parts shrinks the budget — clamp the range back into bounds.
    final cap = maxAllowedPrice;
    if (_condition.maxPrice > cap) {
      _condition = _condition.copyWith(
        maxPrice: cap,
        minPrice: _condition.minPrice > cap ? cap : _condition.minPrice,
      );
    }
    notifyListeners();
  }

  void selectSortOption(String sortOption) {
    _condition = _condition.copyWith(sortOption: sortOption);
    notifyListeners();
  }

  void updatePriceRange({
    required double start,
    required double end,
  }) {
    // Snap to 1000원 units so prices stay aligned to the slider step.
    _condition = _condition.copyWith(
      minPrice: (start / 1000).round() * 1000,
      maxPrice: (end / 1000).round() * 1000,
    );
    notifyListeners();
  }

  void reset() {
    _condition = StylingCondition(
      categories: {OutfitPart.top},
      minPrice: 18000,
      maxPrice: 150000,
      sortOption: 'AI 추천순',
    );
    notifyListeners();
  }
}
