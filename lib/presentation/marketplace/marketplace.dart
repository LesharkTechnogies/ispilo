import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/category_chip_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recently_viewed_widget.dart';
import './widgets/search_bar_widget.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'All Categories';
  Map<String, dynamic> _currentFilters = {};
  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _recentlyViewed = [];
  bool _isLoading = false;
  bool _hasMoreProducts = true;
  int _currentPage = 1;

  final List<String> _categories = [
    'All Categories',
    'Hardware',
    'Software',
    'Services',
    'Tools',
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "title": "Cisco Router ASR 1001-X",
      "price": "\$2,499.00",
      "image":
          "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Hardware",
      "rating": 4.8,
      "location": "New York, NY",
      "seller": "TechNet Solutions",
      "condition": "New",
      "description":
          "High-performance enterprise router with advanced security features"
    },
    {
      "id": 2,
      "title": "Ubiquiti UniFi Dream Machine",
      "price": "\$379.00",
      "image":
          "https://images.unsplash.com/photo-1606904825846-647eb07f5be2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Hardware",
      "rating": 4.6,
      "location": "Los Angeles, CA",
      "seller": "Network Pro",
      "condition": "Like New",
      "description": "All-in-one network appliance with built-in controller"
    },
    {
      "id": 3,
      "title": "SolarWinds Network Monitoring",
      "price": "\$1,299.00",
      "image":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Software",
      "rating": 4.4,
      "location": "Chicago, IL",
      "seller": "ISP Tools Inc",
      "condition": "New",
      "description": "Comprehensive network monitoring and management software"
    },
    {
      "id": 4,
      "title": "Fiber Optic Cable Installation",
      "price": "\$89.00/hr",
      "image":
          "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Services",
      "rating": 4.9,
      "location": "Houston, TX",
      "seller": "FiberTech Services",
      "condition": "Service",
      "description":
          "Professional fiber optic cable installation and maintenance"
    },
    {
      "id": 5,
      "title": "Fluke Networks Cable Tester",
      "price": "\$899.00",
      "image":
          "https://images.unsplash.com/photo-1581092160562-40aa08e78837?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Tools",
      "rating": 4.7,
      "location": "Phoenix, AZ",
      "seller": "Test Equipment Co",
      "condition": "Good",
      "description": "Professional cable testing and certification tool"
    },
    {
      "id": 6,
      "title": "Mikrotik RouterBoard RB5009",
      "price": "\$199.00",
      "image":
          "https://images.unsplash.com/photo-1606904825846-647eb07f5be2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Hardware",
      "rating": 4.5,
      "location": "Miami, FL",
      "seller": "Router Depot",
      "condition": "New",
      "description": "High-performance router with 10G SFP+ connectivity"
    },
    {
      "id": 7,
      "title": "PRTG Network Monitor License",
      "price": "\$1,750.00",
      "image":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Software",
      "rating": 4.3,
      "location": "Seattle, WA",
      "seller": "Software Solutions",
      "condition": "New",
      "description": "Enterprise network monitoring software license"
    },
    {
      "id": 8,
      "title": "Network Security Audit",
      "price": "\$150.00/hr",
      "image":
          "https://images.unsplash.com/photo-1563986768609-322da13575f3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Services",
      "rating": 4.8,
      "location": "Boston, MA",
      "seller": "SecureNet Consulting",
      "condition": "Service",
      "description":
          "Comprehensive network security assessment and recommendations"
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
    _scrollController.addListener(_onScroll);
    _loadRecentlyViewed();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    if (_isLoading || !_hasMoreProducts) return;

    setState(() => _isLoading = true);

    // Simulate loading more products
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentPage++;
          // In real app, this would load more products from API
          if (_currentPage > 3) {
            _hasMoreProducts = false;
          }
        });
      }
    });
  }

  void _loadRecentlyViewed() {
    // Simulate loading recently viewed products
    setState(() {
      _recentlyViewed = _allProducts.take(3).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_allProducts);
      } else {
        _filteredProducts = _allProducts.where((product) {
          return (product["title"] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (product["category"] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All Categories') {
        _filteredProducts = List.from(_allProducts);
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product["category"] == category;
        }).toList();
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onApplyFilters: _applyFilters,
      ),
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _filteredProducts = _allProducts.where((product) {
        bool matches = true;

        // Category filter
        if (filters['category'] != null &&
            filters['category'] != 'All Categories') {
          matches = matches && product["category"] == filters['category'];
        }

        // Price range filter
        if (filters['minPrice'] != null && filters['maxPrice'] != null) {
          final price = double.tryParse((product["price"] as String)
                  .replaceAll(RegExp(r'[^\d.]'), '')) ??
              0;
          matches = matches &&
              price >= filters['minPrice'] &&
              price <= filters['maxPrice'];
        }

        // Condition filter
        if (filters['condition'] != null &&
            filters['condition'] != 'Any Condition') {
          matches = matches && product["condition"] == filters['condition'];
        }

        // Rating filter
        if (filters['minRating'] != null) {
          matches = matches && product["rating"] >= filters['minRating'];
        }

        return matches;
      }).toList();
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    // Add to recently viewed
    setState(() {
      _recentlyViewed.removeWhere((p) => p["id"] == product["id"]);
      _recentlyViewed.insert(0, product);
      if (_recentlyViewed.length > 5) {
        _recentlyViewed = _recentlyViewed.take(5).toList();
      }
    });

    Navigator.pushNamed(context, '/product-detail', arguments: product);
  }

  void _onProductLongPress(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsWidget(
        product: product,
        onSave: () => _saveToFavorites(product),
        onShare: () => _shareProduct(product),
        onContact: () => _contactSeller(product),
      ),
    );
  }

  void _saveToFavorites(Map<String, dynamic> product) {
    // Implement save to favorites
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product["title"]} saved to favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareProduct(Map<String, dynamic> product) {
    // Implement product sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${product["title"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _contactSeller(Map<String, dynamic> product) {
    // Implement contact seller
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${product["seller"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    setState(() {
      _filteredProducts = List.from(_allProducts);
      _currentPage = 1;
      _hasMoreProducts = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _createListing() async {
    // Navigate to create listing screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create listing feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onFilterTap: _showFilterBottomSheet,
              hintText: 'Search products...',
              fontSize: 10.sp,
            ),

            // Category Chips
            Container(
              height: 4.5.h,
              margin: EdgeInsets.symmetric(vertical: 0.5.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryChipWidget(
                    label: category,
                    isSelected: _selectedCategory == category,
                    onTap: () => _onCategorySelected(category),
                    fontSize: 9.sp,
                  );
                },
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Products Grid
                    _filteredProducts.isEmpty
                        ? _buildEmptyState(colorScheme)
                        : SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 2.w,
                                mainAxisSpacing: 2.w,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index < _filteredProducts.length) {
                                    final product = _filteredProducts[index];
                                    return ProductCardWidget(
                                      product: product,
                                      onTap: () => _onProductTap(product),
                                      onLongPress: () =>
                                          _onProductLongPress(product),
                                    );
                                  } else {
                                    return _buildLoadingCard(colorScheme);
                                  }
                                },
                                childCount: _filteredProducts.length +
                                    (_isLoading ? 2 : 0),
                              ),
                            ),
                          ),

                    // Recently Viewed Section (moved to bottom)
                    if (_recentlyViewed.isNotEmpty)
                      SliverToBoxAdapter(
                        child: RecentlyViewedWidget(
                          recentProducts: _recentlyViewed,
                          onProductTap: _onProductTap,
                        ),
                      ),

                    // Loading indicator
                    if (_isLoading)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),

                    // End of results
                    if (!_hasMoreProducts && _filteredProducts.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          child: Text(
                            'No more products to load',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button (Android) / Prominent Button (iOS)
      floatingActionButton: Theme.of(context).platform == TargetPlatform.iOS
          ? null
          : FloatingActionButton.extended(
              onPressed: _createListing,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: CustomIconWidget(
                iconName: 'add',
                color: colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                'Sell Something',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 2,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No products found',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            TextButton(
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
                _onCategorySelected('All Categories');
                setState(() => _currentFilters.clear());
              },
              child: Text(
                'Clear all filters',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.2),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 2.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 1.5.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
