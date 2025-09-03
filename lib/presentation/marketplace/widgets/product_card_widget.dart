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
        margin: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      product["title"] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 0.5.h),

                    // Price
                    Text(
                      product["price"] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    // Seller Info Row
                    Row(
                      children: [
                        // Rating
                        CustomIconWidget(
                          iconName: 'star',
                          color: Colors.amber,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          product["rating"].toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),

                        const Spacer(),

                        // Location
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Flexible(
                          child: Text(
                            product["location"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
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
    );
  }
}