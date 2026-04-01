class StylingCondition {
  const StylingCondition({
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.priceRangeLabel,
    required this.sortOption,
  });

  final String category;
  final int minPrice;
  final int maxPrice;
  final String priceRangeLabel;
  final String sortOption;

  StylingCondition copyWith({
    String? category,
    int? minPrice,
    int? maxPrice,
    String? priceRangeLabel,
    String? sortOption,
  }) {
    return StylingCondition(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      priceRangeLabel: priceRangeLabel ?? this.priceRangeLabel,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
