import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/result/model/result_item.dart';

enum ResultTab { wearingItems, recommendations }

class ResultViewModel extends ChangeNotifier {
  ResultViewModel({required this.items});

  final List<ResultItem> items;

  ResultTab _selectedTab = ResultTab.wearingItems;
  OutfitPart? _selectedCategory;
  String? _selectedItemId;

  ResultTab get selectedTab => _selectedTab;
  OutfitPart? get selectedCategory => _selectedCategory;
  bool isItemSelected(String id) => _selectedItemId == id;

  List<ResultItem> get filteredItems {
    if (_selectedCategory == null) return items;
    return items.where((i) => i.outfitPart == _selectedCategory).toList();
  }

  void selectTab(ResultTab tab) {
    _selectedTab = tab;
    notifyListeners();
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
