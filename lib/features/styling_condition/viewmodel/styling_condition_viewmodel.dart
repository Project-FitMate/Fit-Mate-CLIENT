import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/styling_condition/model/styling_condition.dart';

class StylingConditionViewModel extends ChangeNotifier {
  // Display order for the category chips. Korean labels map to OutfitPart via fromLabel().
  static const categoryOptions = ['전신', '상의', '하의', '아우터', '원피스', '신발', '모자'];
  // Client-side only sort options; not sent to the server.
  static const sortOptions = ['AI 추천순', '가격 낮은순', '인기순', '신상품'];
  static const minAllowedPrice = 0;
  static const maxAllowedPrice = 500000;

  StylingCondition _condition = StylingCondition(
    category: OutfitPart.full,
    minPrice: 18000,
    maxPrice: 150000,
    sortOption: 'AI 추천순',
  );

  StylingCondition get condition => _condition;

  // Single-selection: tapping a chip replaces the current category.
  void selectCategory(String categoryLabel) {
    _condition = _condition.copyWith(
      category: OutfitPart.fromLabel(categoryLabel),
    );
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
    _condition = _condition.copyWith(
      minPrice: start.round(),
      maxPrice: end.round(),
    );
    notifyListeners();
  }

  void reset() {
    _condition = StylingCondition(
      category: OutfitPart.full,
      minPrice: 18000,
      maxPrice: 150000,
      sortOption: 'AI 추천순',
    );
    notifyListeners();
  }
}
