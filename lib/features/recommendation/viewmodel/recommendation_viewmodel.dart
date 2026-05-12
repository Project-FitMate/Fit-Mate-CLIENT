import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/repository/recommendation_repository.dart';

enum RecommendationStatus { initial, loading, success, error }

class RecommendationViewModel extends ChangeNotifier {
  RecommendationViewModel({
    required this.categories,
  }) : _repository = RecommendationRepository() {
    _load();
  }

  final List<String> categories;
  final RecommendationRepository _repository;

  RecommendationStatus _status = RecommendationStatus.initial;
  List<RecommendedProduct> _allProducts = [];
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedCategory;

  // clothingType별로 선택된 productId 저장 (카테고리당 1개)
  final Map<ClothingType, String> _selectedByType = {};

  RecommendationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;
  bool get hasSelection => _selectedByType.isNotEmpty;

  bool isSelected(String productId) => _selectedByType.containsValue(productId);

  List<RecommendedProduct> get products {
    var filtered = _selectedCategory == null
        ? _allProducts
        : _allProducts.where((p) => p.clothingType.label == _selectedCategory).toList();

    if (_searchQuery.isEmpty) return filtered;
    final q = _searchQuery.toLowerCase();
    return filtered.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> _load() async {
    _status = RecommendationStatus.loading;
    notifyListeners();
    try {
      _allProducts = await _repository.fetchByCategories(categories);
      _status = RecommendationStatus.success;
    } catch (e) {
      _errorMessage = '추천 아이템을 불러오지 못했습니다.';
      _status = RecommendationStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => _load();

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSelection(String productId) {
    final product = _allProducts.firstWhere((p) => p.id == productId);
    final type = product.clothingType;

    if (_selectedByType[type] == productId) {
      // 같은 상품 다시 누르면 해제
      _selectedByType.remove(type);
    } else {
      // 같은 카테고리의 기존 선택을 덮어씀
      _selectedByType[type] = productId;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedByType.clear();
    notifyListeners();
  }
}
