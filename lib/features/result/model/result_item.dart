import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class ResultItem {
  const ResultItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.outfitPart,
    this.productUrl = '',
  });

  final String id;
  final String name;
  final String brand;
  final int price;
  final String imageUrl;
  final OutfitPart? outfitPart;
  final String productUrl;

  factory ResultItem.fromProduct(RecommendedProduct p) => ResultItem(
        id: p.id,
        name: p.name,
        brand: p.brand,
        price: p.price,
        imageUrl: p.imageUrl,
        outfitPart: p.outfitPart,
        productUrl: p.productUrl,
      );
}
