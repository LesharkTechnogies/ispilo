import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      child: Container(
  margin: EdgeInsets.all(0.5.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (smaller height)
            SizedBox(
              height: 8.5.h,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Hero(
                  tag: 'product-${product["id"]}',
                  child: CustomImageWidget(
                    imageUrl: product["image"] as String,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.all(1.2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    product["title"] as String,
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 0.3.h),

                  // Price
                  Text(
                    product["price"] as String,
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: 0.3.h),

                  // Seller Info Row
                  Row(
                    children: [
                      // Rating
                      CustomIconWidget(
                        iconName: 'star',
                        color: Colors.amber,
                        size: 10,
                      ),
                      SizedBox(width: 0.7.w),
                      Text(
                        product["rating"].toString(),
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),

                      const Spacer(),

                      // Location
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: colorScheme.onSurface.withOpacity(0.6),
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        product["location"] as String,
                        style: GoogleFonts.inter(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
