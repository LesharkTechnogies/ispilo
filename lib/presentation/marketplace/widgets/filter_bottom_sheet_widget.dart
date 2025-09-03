import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';


class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(0, 10000);

  final List<String> _categories = [
    'All Categories',
    'Hardware',
    'Software',
    'Services',
    'Tools',
  ];

  final List<String> _conditions = [
    'Any Condition',
    'New',
    'Like New',
    'Good',
    'Fair',
  ];

  final List<String> _locations = [
    'Any Location',
    'Within 10 miles',
    'Within 25 miles',
    'Within 50 miles',
    'Within 100 miles',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] ?? 0).toDouble(),
      (_filters['maxPrice'] ?? 10000).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(colorScheme),
                  SizedBox(height: 3.h),
                  _buildPriceRangeSection(colorScheme),
                  SizedBox(height: 3.h),
                  _buildConditionSection(colorScheme),
                  SizedBox(height: 3.h),
                  _buildLocationSection(colorScheme),
                  SizedBox(height: 3.h),
                  _buildRatingSection(colorScheme),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories.map((category) {
            final isSelected = _filters['category'] == category;
            return GestureDetector(
              onTap: () => setState(() => _filters['category'] = category),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 10000,
          divisions: 100,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) => setState(() => _priceRange = values),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConditionSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Condition',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ..._conditions.map((condition) {
          final isSelected = _filters['condition'] == condition;
          return RadioListTile<String>(
            title: Text(
              condition,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: colorScheme.onSurface,
              ),
            ),
            value: condition,
            groupValue: _filters['condition'],
            onChanged: (value) => setState(() => _filters['condition'] = value),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLocationSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ..._locations.map((location) {
          return RadioListTile<String>(
            title: Text(
              location,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: colorScheme.onSurface,
              ),
            ),
            value: location,
            groupValue: _filters['location'],
            onChanged: (value) => setState(() => _filters['location'] = value),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRatingSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Slider(
          value: (_filters['minRating'] ?? 0).toDouble(),
          min: 0,
          max: 5,
          divisions: 5,
          label: '${(_filters['minRating'] ?? 0).toDouble()} stars',
          onChanged: (value) => setState(() => _filters['minRating'] = value),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _filters.clear();
      _priceRange = const RangeValues(0, 10000);
    });
  }

  void _applyFilters() {
    _filters['minPrice'] = _priceRange.start.round();
    _filters['maxPrice'] = _priceRange.end.round();
    widget.onApplyFilters(_filters);
    Navigator.pop(context);
  }
}