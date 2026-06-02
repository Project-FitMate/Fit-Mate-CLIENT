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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'price': price,
        'imageUrl': imageUrl,
        'part': outfitPart?.wire,
        'productUrl': productUrl,
      };

  factory ResultItem.fromJson(Map<String, dynamic> json) => ResultItem(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        brand: (json['brand'] ?? '') as String,
        price: (json['price'] as num?)?.toInt() ?? 0,
        imageUrl: (json['imageUrl'] ?? '') as String,
        outfitPart: OutfitPart.fromWire(json['part'] as String?),
        productUrl: (json['productUrl'] ?? '') as String,
      );
}
