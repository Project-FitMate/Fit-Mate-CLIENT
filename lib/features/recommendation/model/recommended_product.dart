enum OutfitPart {
  full('FULL', '전신'),
  top('TOP', '상의'),
  bottom('BOTTOM', '하의'),
  outer('OUTER', '아우터'),
  dress('DRESS', '원피스'),
  shoes('SHOES', '신발'),
  hat('HAT', '모자');

  const OutfitPart(this.wire, this.label);

  final String wire;
  final String label;

  static OutfitPart fromLabel(String label) {
    return OutfitPart.values.firstWhere(
      (e) => e.label == label,
      orElse: () => OutfitPart.top,
    );
  }
}

class RecommendedProduct {
  const RecommendedProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.productUrl,
    this.outfitPart,
    this.originalPrice,
    this.discountRate,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String brand;
  final int price;
  final int? originalPrice;
  final int? discountRate;
  final String imageUrl;
  final OutfitPart? outfitPart;
  final String productUrl;
  final List<String> tags;

  factory RecommendedProduct.fromJson(Map<String, dynamic> json, {OutfitPart? part}) {
    final link = (json['link'] ?? '') as String;
    return RecommendedProduct(
      id: link.isEmpty ? json['name'].toString() : link,
      name: (json['name'] ?? '') as String,
      brand: (json['brand'] ?? '') as String,
      price: (json['price'] as num?)?.toInt() ?? 0,
      imageUrl: (json['image'] ?? '') as String,
      productUrl: link,
      outfitPart: part,
    );
  }
}
