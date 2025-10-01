import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

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
        // Remove horizontal margins since grid provides spacing, keep minimal vertical margin
        margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.6.h),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.hardEdge,
          child: LayoutBuilder(builder: (context, constraints) {
            final totalHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : 200.0; // fallback in case of weird constraints
            final imageHeight = totalHeight * 0.66;
            // subtract a tiny epsilon to avoid 1-2px rounding overflow
            final detailsHeight =
                math.max(0.0, totalHeight - imageHeight - 2.0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image (2/3)
                SizedBox(
                  height: imageHeight,
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

                // Details (1/3)
                SizedBox(
                  height: detailsHeight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 0.8.h, // Add spacing between image and content
                        left: 0.6.w,
                        right: 0.6.w,
                        bottom: 0.4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          product["title"] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          product["price"] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 0.2.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: Colors.amber,
                              size: 10,
                            ),
                            SizedBox(width: 0.6.w),
                            Text(
                              product["rating"].toString(),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            const Spacer(),
                            CustomIconWidget(
                              iconName: 'location_on',
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                              size: 12,
                            ),
                            SizedBox(width: 0.8.w),
                            Expanded(
                              child: Text(
                                product["location"] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.7),
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
            );
          }),
        ),
      ),
    );
  }
}
