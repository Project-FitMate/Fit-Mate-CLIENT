import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/repository/recommendation_repository.dart';

enum RecommendationStatus { initial, loading, success, error }

class RecommendationViewModel extends ChangeNotifier {
  RecommendationViewModel({
    required this.part,
    required this.minPrice,
    required this.maxPrice,
    required this.userImageName,
    RecommendationRepository? repository,
  }) : _repository = repository ?? RecommendationRepository() {
    _load();
  }

  final OutfitPart part;
  final int minPrice;
  final int maxPrice;
  final String userImageName;
  final RecommendationRepository _repository;

  RecommendationStatus _status = RecommendationStatus.initial;
  List<RecommendedProduct> _products = [];
  String? _errorMessage;
  String _searchQuery = '';

  String? _selectedId;

  RecommendationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int get selectedCount => _selectedId == null ? 0 : 1;
  bool get hasSelection => _selectedId != null;

  RecommendedProduct? get selectedProduct {
    if (_selectedId == null) return null;
    return _products.firstWhere(
      (p) => p.id == _selectedId,
      orElse: () => _products.first,
    );
  }

  bool isSelected(String productId) => _selectedId == productId;

  // Client-side only filter; never sent to the server.
  List<RecommendedProduct> get products {
    if (_searchQuery.isEmpty) return _products;
    final q = _searchQuery.toLowerCase();
    return _products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  Future<void> _load() async {
    _status = RecommendationStatus.loading;
    notifyListeners();
    try {
      _products = await _repository.fetch(
        part: part,
        minPrice: minPrice,
        maxPrice: maxPrice,
        userImageName: userImageName,
      );
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

  // Single-selection: tapping a card replaces the current selection.
  void toggleSelection(String productId) {
    if (_selectedId == productId) {
      _selectedId = null;
    } else {
      _selectedId = productId;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedId = null;
    notifyListeners();
  }
}
