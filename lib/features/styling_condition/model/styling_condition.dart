import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class StylingCondition {
  const StylingCondition({
    required this.categories,
    required this.minPrice,
    required this.maxPrice,
    required this.sortOption,
  });

  // Multi-selection categories, aligned with the LLM/server OutfitPart enum.
  final Set<OutfitPart> categories;
  final int minPrice;
  final int maxPrice;
  // Client-side only display option; not sent to the server.
  final String sortOption;

  StylingCondition copyWith({
    Set<OutfitPart>? categories,
    int? minPrice,
    int? maxPrice,
    String? sortOption,
  }) {
    return StylingCondition(
      categories: categories ?? this.categories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
