import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/result/model/result_item.dart';

class ResultViewModel extends ChangeNotifier {
  ResultViewModel({required this.items});

  final List<ResultItem> items;

  OutfitPart? _selectedCategory;
  String? _selectedItemId;

  OutfitPart? get selectedCategory => _selectedCategory;
  bool isItemSelected(String id) => _selectedItemId == id;

  // Parts actually present in the result, in canonical order — drives the
  // category chips so categories with no items aren't shown.
  List<OutfitPart> get availableParts =>
      OutfitPart.values.where((p) => items.any((i) => i.outfitPart == p)).toList();

  List<ResultItem> get filteredItems {
    if (_selectedCategory == null) return items;
    return items.where((i) => i.outfitPart == _selectedCategory).toList();
  }

  void selectCategory(OutfitPart? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleItem(String id) {
    _selectedItemId = _selectedItemId == id ? null : id;
    notifyListeners();
  }
}
