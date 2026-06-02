import 'package:fit_mate_client/core/device/device_id.dart';
import 'package:fit_mate_client/core/network/api_client.dart';
import 'package:fit_mate_client/features/result/model/try_on_result.dart';

class FittingRepository {
  FittingRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<TryOnResult> create({
    required String userImageName,
    required List<String> outfitImageUrls,
  }) async {
    final deviceId = await DeviceId.get();
    final data = await _apiClient.postJson(
      '/fitting',
      {
        'userImageName': userImageName,
        'outfitImageUrls': outfitImageUrls,
      },
      headers: {'device-id': deviceId},
    );
    final image = (data as Map<String, dynamic>)['image'] as String;
    return TryOnResult(imageBase64: image);
  }
}
