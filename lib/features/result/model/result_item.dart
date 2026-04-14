import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class ResultItem {
  const ResultItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.clothingType,
    this.productUrl = '',
  });

  final String id;
  final String name;
  final String brand;
  final int price;
  final String imageUrl;
  final ClothingType clothingType;
  final String productUrl;
}
