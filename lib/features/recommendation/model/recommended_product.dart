enum ClothingType {
  top('상의'),
  bottom('하의'),
  outer('아우터'),
  shoes('신발'),
  accessory('액세서리');

  const ClothingType(this.label);

  final String label;

  static ClothingType fromLabel(String label) {
    return ClothingType.values.firstWhere(
      (e) => e.label == label,
      orElse: () => ClothingType.top,
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
    required this.clothingType,
    this.originalPrice,
    this.discountRate,
    this.productUrl = '',
    this.tags = const [],
  });

  final String id;
  final String name;
  final String brand;
  final int price;
  final int? originalPrice;
  final int? discountRate;
  final String imageUrl;
  final ClothingType clothingType;
  final String productUrl;
  final List<String> tags;
}
