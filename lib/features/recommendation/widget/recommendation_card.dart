import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  final RecommendedProduct product;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isSelected ? ColorConstants.rose : const Color(0xFFE5E7EB),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImage(imageUrl: product.imageUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.brand,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _CheckBox(isSelected: isSelected),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _PriceRow(
                      price: product.price,
                      originalPrice: product.originalPrice,
                      discountRate: product.discountRate,
                    ),
                    const SizedBox(height: 6),
                    _ShopLink(brand: product.brand),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 112,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            )
          : const Center(
              child: Icon(
                Icons.checkroom_outlined,
                size: 40,
                color: Color(0xFFCDD2DA),
              ),
            ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? ColorConstants.rose : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? ColorConstants.rose : const Color(0xFFD1D5DB),
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : null,
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.price,
    required this.originalPrice,
    required this.discountRate,
  });

  final int price;
  final int? originalPrice;
  final int? discountRate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '₩${_fmt(price)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 6),
          Text(
            '₩${_fmt(originalPrice!)}',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              decoration: TextDecoration.lineThrough,
              decorationColor: Color(0xFF9CA3AF),
            ),
          ),
          if (discountRate != null) ...[
            const SizedBox(width: 4),
            Text(
              '-$discountRate%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ColorConstants.rose,
              ),
            ),
          ],
        ],
      ],
    );
  }

  String _fmt(int price) => price
      .toString()
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _ShopLink extends StatelessWidget {
  const _ShopLink({required this.brand});

  final String brand;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.link_rounded, size: 14, color: ColorConstants.rose),
        const SizedBox(width: 2),
        Text(
          '$brand 바로가기',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: ColorConstants.rose,
          ),
        ),
        const SizedBox(width: 2),
        Transform.rotate(
          angle: -0.785,
          child: const Icon(
            Icons.arrow_forward_rounded,
            size: 12,
            color: ColorConstants.rose,
          ),
        ),
      ],
    );
  }
}
