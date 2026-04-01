class StylingCondition {
  const StylingCondition({
    required this.categories,
    required this.minPrice,
    required this.maxPrice,
    required this.priceRangeLabel,
    required this.sortOption,
  });

  final List<String> categories;
  final int minPrice;
  final int maxPrice;
  final String priceRangeLabel;
  final String sortOption;

  StylingCondition copyWith({
    List<String>? categories,
    int? minPrice,
    int? maxPrice,
    String? priceRangeLabel,
    String? sortOption,
  }) {
    return StylingCondition(
      categories: categories ?? this.categories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      priceRangeLabel: priceRangeLabel ?? this.priceRangeLabel,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
