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
    this.sortOption = 'AI 추천순',
    RecommendationRepository? repository,
  }) : _repository = repository ?? RecommendationRepository() {
    _load();
  }

  final List<OutfitPart> parts;
  final int minPrice;
  final int maxPrice;
  final String userImageName;
  final String sortOption;
  final RecommendationRepository _repository;

  // Each garment spans 0~500,000원; the budget scales with the part count.
  static const _maxPricePerPart = 500000;

  RecommendationStatus _status = RecommendationStatus.initial;
  List<RecommendedProduct> _products = [];
  String? _errorMessage;
  String _searchQuery = '';

  // Per-part selection: part → the chosen product. Storing the product itself
  // (not just its id) keeps picks alive when a new server search replaces the
  // product list. Picking another product in the same part replaces it.
  final Map<OutfitPart?, RecommendedProduct> _selectedByPart = {};
  // Category filter chip; null means "전체". Filters the list by item part.
  OutfitPart? _selectedCategory;

  RecommendationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  // Now counts the number of selected parts.
  int get selectedCount => _selectedByPart.length;
  bool get hasSelection => _selectedByPart.isNotEmpty;
  OutfitPart? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  // Total loaded items, ignoring the active category/search filter.
  int get totalCount => _products.length;

  // The selected products, retained across searches.
  List<RecommendedProduct> get selectedProducts =>
      _selectedByPart.values.toList();

  bool isSelected(String productId) =>
      _selectedByPart.values.any((p) => p.id == productId);

  // Client-side only filter + sort; never sent to the server.
  List<RecommendedProduct> get products {
    var list = _products;
    if (_selectedCategory != null) {
      list = list.where((p) => p.outfitPart == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    }
    switch (sortOption) {
      case '가격 낮은순':
        list = [...list]..sort((a, b) => a.price.compareTo(b.price));
        break;
      case '가격 높은순':
        list = [...list]..sort((a, b) => b.price.compareTo(a.price));
        break;
      // 'AI 추천순' keeps the original server order.
    }
    return list;
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

  // Re-query the server with a user keyword. The active category chip decides
  // the scope: "전체" re-searches and replaces every selected part, while a
  // specific part (상의/모자/…) re-searches only that part and merges the fresh
  // results in, leaving the other parts untouched. Clears the text filter.
  Future<void> searchOnServer(String keyword) async {
    final category = _selectedCategory;
    final targetParts = category == null ? parts : [category];
    // Single-part re-search must respect that part's budget (500,000), so clamp
    // the multi-part price range down or the server rejects it.
    final budget = _maxPricePerPart * targetParts.length;
    final effMaxPrice = maxPrice > budget ? budget : maxPrice;
    final effMinPrice = minPrice > effMaxPrice ? effMaxPrice : minPrice;

    _searchQuery = '';
    _status = RecommendationStatus.loading;
    notifyListeners();
    try {
      final fetched = await _repository.fetch(
        parts: targetParts,
        minPrice: effMinPrice,
        maxPrice: effMaxPrice,
        userImageName: userImageName,
        keyword: keyword,
      );
      _products = category == null
          ? fetched
          : [
              ..._products.where((p) => p.outfitPart != category),
              ...fetched,
            ];
      _status = RecommendationStatus.success;
    } catch (e, st) {
      debugPrint('[RecommendationVM] server search failed: $e\n$st');
      _errorMessage = '검색에 실패했습니다.';
      _status = RecommendationStatus.error;
    }
    notifyListeners();
  }

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
    if (_selectedByPart[part]?.id == productId) {
      _selectedByPart.remove(part);
    } else {
      _selectedByPart[part] = product;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedByPart.clear();
    notifyListeners();
  }
}
