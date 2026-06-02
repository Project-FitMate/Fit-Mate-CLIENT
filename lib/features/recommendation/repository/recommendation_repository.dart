import 'package:fit_mate_client/core/network/api_client.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class RecommendationRepository {
  RecommendationRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<RecommendedProduct>> fetch({
    required List<OutfitPart> parts,
    required int minPrice,
    required int maxPrice,
    required String userImageName,
  }) async {
    final body = {
      'parts': parts.map((e) => e.wire).toList(),
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'userImageName': userImageName,
    };
    final data = await _apiClient.postJson('/outfit', body);
    final list = (data as List).cast<Map<String, dynamic>>();
    return list.map((item) => RecommendedProduct.fromJson(item)).toList();
  }
}
