// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/repository/recommendation_repository.dart';

enum RecommendationStatus { initial, loading, success, error }

class RecommendationViewModel extends ChangeNotifier {
  RecommendationViewModel({
    required this.parts,
    required this.minPrice,
    required this.maxPrice,
    required this.userImageName,
    RecommendationRepository? repository,
  }) : _repository = repository ?? RecommendationRepository() {
    _load();
  }

  final List<OutfitPart> parts;
  final int minPrice;
  final int maxPrice;
  final String userImageName;
  final RecommendationRepository _repository;

  RecommendationStatus _status = RecommendationStatus.initial;
  List<RecommendedProduct> _products = [];
  String? _errorMessage;
  String _searchQuery = '';

  // Per-part selection: key=product's outfitPart, value=productId.
  // Picking another product in the same part replaces that part's selection.
  final Map<OutfitPart?, String> _selectedByPart = {};
  // Category filter chip; null means "전체". Filters the list by item part.
  OutfitPart? _selectedCategory;

  RecommendationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  // Now counts the number of selected parts.
  int get selectedCount => _selectedByPart.length;
  bool get hasSelection => _selectedByPart.isNotEmpty;
  OutfitPart? get selectedCategory => _selectedCategory;
  // Total loaded items, ignoring the active category/search filter.
  int get totalCount => _products.length;

  // Maps the currently selected product ids back to products.
  List<RecommendedProduct> get selectedProducts {
    final ids = _selectedByPart.values.toSet();
    return _products.where((p) => ids.contains(p.id)).toList();
  }

  bool isSelected(String productId) => _selectedByPart.values.contains(productId);

  // Client-side only filter; never sent to the server.
  List<RecommendedProduct> get products {
    var list = _products;
    if (_selectedCategory != null) {
      list = list.where((p) => p.outfitPart == _selectedCategory).toList();
    }
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  // null clears the filter (전체).
  void selectCategory(OutfitPart? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> _load() async {
    _status = RecommendationStatus.loading;
    notifyListeners();
    try {
      _products = await _repository.fetch(
        parts: parts,
        minPrice: minPrice,
        maxPrice: maxPrice,
        userImageName: userImageName,
      );
      debugPrint('[RecommendationVM] loaded ${_products.length} products, searchQuery="$_searchQuery"');
      _status = RecommendationStatus.success;
    } catch (e, st) {
      debugPrint('[RecommendationVM] load failed: $e\n$st');
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

  // Per-part selection: tapping a card toggles it within its outfit part.
  // Tapping another product in the same part replaces that part's selection.
  void toggleSelection(String productId) {
    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => _products.first,
    );
    final part = product.outfitPart;
    if (_selectedByPart[part] == productId) {
      _selectedByPart.remove(part);
    } else {
      _selectedByPart[part] = productId;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedByPart.clear();
    notifyListeners();
  }
}
