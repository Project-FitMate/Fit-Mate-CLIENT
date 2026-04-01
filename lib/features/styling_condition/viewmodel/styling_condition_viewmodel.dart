import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/styling_condition/model/styling_condition.dart';

class StylingConditionViewModel extends ChangeNotifier {
  static const categoryOptions = ['전신', '상의', '하의', '아우터', '원피스', '신발'];
  static const sortOptions = ['AI 추천순', '가격 낮은순', '인기순', '신상품'];
  static const priceRangeOptions = ['~3만원', '3~10만원', '10~20만원', '20만원+'];

  StylingCondition _condition = const StylingCondition(
    categories: ['전신'],
    minPrice: 18000,
    maxPrice: 150000,
    priceRangeLabel: '3~10만원',
    sortOption: 'AI 추천순',
  );

  StylingCondition get condition => _condition;

  void toggleCategory(String category) {
    final nextCategories = List<String>.from(_condition.categories);

    if (nextCategories.contains(category)) {
      if (nextCategories.length == 1) {
        return;
      }
      nextCategories.remove(category);
    } else {
      nextCategories.add(category);
    }

    _condition = _condition.copyWith(categories: nextCategories);
    notifyListeners();
  }

  void selectSortOption(String sortOption) {
    _condition = _condition.copyWith(sortOption: sortOption);
    notifyListeners();
  }

  void selectPriceRange(String rangeLabel) {
    _condition = _condition.copyWith(priceRangeLabel: rangeLabel);
    notifyListeners();
  }

  void reset() {
    _condition = const StylingCondition(
      categories: ['전신'],
      minPrice: 18000,
      maxPrice: 150000,
      priceRangeLabel: '3~10만원',
      sortOption: 'AI 추천순',
    );
    notifyListeners();
  }
}
