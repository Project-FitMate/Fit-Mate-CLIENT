import 'package:flutter/foundation.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/repository/recommendation_repository.dart';

enum RecommendationStatus { initial, loading, success, error }

class RecommendationViewModel extends ChangeNotifier {
  RecommendationViewModel({
    required this.clothingType,
    RecommendationRepository? repository,
  }) : _repository = repository ?? RecommendationRepository() {
    _load();
  }

  final ClothingType clothingType;
  final RecommendationRepository _repository;

  RecommendationStatus _status = RecommendationStatus.initial;
  List<RecommendedProduct> _products = [];
  String? _errorMessage;
  String _searchQuery = '';

  final Set<String> _selectedIds = {};

  RecommendationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int get selectedCount => _selectedIds.length;
  bool get hasSelection => _selectedIds.isNotEmpty;

  bool get canSelect => _selectedIds.length < 3;

  bool isSelected(String productId) => _selectedIds.contains(productId);

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
      _products = await _repository.fetchByType(clothingType);
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
    if (_selectedIds.contains(productId)) {
      _selectedIds.remove(productId);
    } else if (canSelect) {
      _selectedIds.add(productId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }
}
