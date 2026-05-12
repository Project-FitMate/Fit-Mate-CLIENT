import 'package:fit_mate_client/core/network/api_client.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class RecommendationRepository {
  RecommendationRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<RecommendedProduct>> fetch({
    required OutfitPart part,
    required int minPrice,
    required int maxPrice,
    required String userImageName,
  }) async {
    final body = {
      'part': part.wire,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'userImageName': userImageName,
    };
    final data = await _apiClient.postJson('/outfit', body);
    final list = (data as List).cast<Map<String, dynamic>>();
    return list
        .map((item) => RecommendedProduct.fromJson(item, part: part))
        .toList();
  }
}
