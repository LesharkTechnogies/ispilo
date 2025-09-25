import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

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
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          SizedBox(
            height: 10.h,
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
      child: Container(
  width: 18.w,
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            SizedBox(
              height: 5.5.h,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: product["image"] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.all(1.2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: 0.2.h),
                  Text(
                    product["price"] as String,
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
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