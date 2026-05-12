import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class StylingCondition {
  const StylingCondition({
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.sortOption,
  });

  // Single-selection category, aligned with the LLM/server OutfitPart enum.
  final OutfitPart category;
  final int minPrice;
  final int maxPrice;
  // Client-side only display option; not sent to the server.
  final String sortOption;

  StylingCondition copyWith({
    OutfitPart? category,
    int? minPrice,
    int? maxPrice,
    String? sortOption,
  }) {
    return StylingCondition(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
