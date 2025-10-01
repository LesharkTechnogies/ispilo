import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class RecentlyViewedWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentProducts;
  final Function(Map<String, dynamic>) onProductTap;

  const RecentlyViewedWidget({
    super.key,
    required this.recentProducts,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (recentProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Recently Viewed',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          SizedBox(
            height: 240, // Match related products carousel height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: recentProducts.length,
              itemBuilder: (context, index) {
                final product = recentProducts[index];
                return _buildRecentProductCard(context, product, colorScheme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProductCard(
    BuildContext context,
    Map<String, dynamic> product,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () => onProductTap(product),
      child: SizedBox(
        width: 160, // Match related products card width
        height: 240, // Match related products card height
        child: Container(
          margin: const EdgeInsets.only(right: 12), // Match related products margin
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120, // Match related products image height
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomImageWidget(
                    imageUrl: product["image"] as String,
                    width: 160, // Match related products image width
                    height: 120, // Match related products image height
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Product Info - Match related products format
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12), // Match related products padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        product["title"] as String,
                        style: GoogleFonts.inter(
                          fontSize: 14, // Match related products title font size
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8), // Match related products spacing

                      // Price
                      Text(
                        product["price"] as String,
                        style: GoogleFonts.inter(
                          fontSize: 16, // Match related products price font size
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),

                      const SizedBox(height: 4), // Small spacing for seller info

                      // Seller Info - Unique to recently viewed
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              product["seller"] as String,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(), // Push rating to bottom

                      // Rating - Match related products format
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: Colors.amber,
                            size: 14, // Match related products star size
                          ),
                          const SizedBox(width: 4), // Match related products spacing
                          Text(
                            product["rating"].toString(),
                            style: GoogleFonts.inter(
                              fontSize: 12, // Match related products rating font size
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
