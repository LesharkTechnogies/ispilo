import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_bar.dart';
import './widgets/expandable_description.dart';
import './widgets/product_image_gallery.dart';
import './widgets/product_info_section.dart';
import './widgets/related_products_carousel.dart';
import './widgets/seller_profile_section.dart';
import './widgets/shipping_policy_section.dart';
import './widgets/specifications_section.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _isSaved = false;
  late Map<String, dynamic> _productData;
  late List<Map<String, dynamic>> _relatedProducts;

  @override
  void initState() {
    super.initState();
    _initializeProductData();
  }

  void _initializeProductData() {
    _productData = {
      "id": "prod_001",
      "title": "Cisco Catalyst 2960-X Series 48-Port Gigabit Ethernet Switch",
      "price": "\$2,850.00",
      "condition": "Like New",
      "rating": 4.8,
      "reviewCount": 127,
      "images": [
        "https://images.pexels.com/photos/442150/pexels-photo-442150.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/325229/pexels-photo-325229.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/159304/network-cable-ethernet-computer-159304.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/163064/play-stone-network-networked-interactive-163064.jpeg?auto=compress&cs=tinysrgb&w=800"
      ],
      "description":
          """Professional-grade network switch perfect for small to medium business environments. This Cisco Catalyst 2960-X Series switch delivers reliable Layer 2 switching with advanced security features and energy efficiency.

Features include 48 x 10/100/1000 Ethernet ports, 4 x 1G SFP uplinks, advanced QoS capabilities, and comprehensive security features including 802.1X authentication and port security.

The switch has been thoroughly tested and is in excellent working condition. All original accessories and documentation included. Perfect for expanding your network infrastructure with enterprise-grade reliability.

Ideal for ISP deployments, corporate networks, and data center edge applications. Supports advanced features like VLAN, STP, RSTP, and MSTP for optimal network performance and redundancy.""",
      "seller": {
        "name": "NetworkPro Solutions",
        "avatar":
            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=200",
        "isVerified": true,
        "rating": 4.9,
        "totalSales": 342
      },
      "specifications": {
        "Model": "WS-C2960X-48FPD-L",
        "Ports": "48 x 10/100/1000 + 4 x 1G SFP",
        "Switching Capacity": "176 Gbps",
        "Forwarding Rate": "130.95 Mpps",
        "MAC Address Table": "16,000 entries",
        "Power Consumption": "370W maximum",
        "Dimensions": "44.5 x 44.5 x 4.4 cm",
        "Weight": "5.9 kg",
        "Operating Temperature": "0°C to 45°C",
        "Warranty": "Limited lifetime hardware warranty"
      },
      "shipping": {
        "info":
            "Fast and secure shipping with professional packaging. All items are tested before shipment and include tracking information. We use specialized carriers experienced with networking equipment.",
        "estimatedDelivery": "3-5 business days",
        "cost": "Free shipping",
        "returnPolicy":
            "30-day return policy. Items must be in original condition with all accessories. Return shipping costs are covered by seller for defective items. Restocking fee may apply for non-defective returns."
      }
    };

    _relatedProducts = [
      {
        "id": "prod_002",
        "title": "Cisco ASA 5506-X Firewall",
        "price": "\$1,250.00",
        "image":
            "https://images.pexels.com/photos/442150/pexels-photo-442150.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.7
      },
      {
        "id": "prod_003",
        "title": "Ubiquiti UniFi Switch 24-Port",
        "price": "\$379.00",
        "image":
            "https://images.pexels.com/photos/325229/pexels-photo-325229.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.6
      },
      {
        "id": "prod_004",
        "title": "Netgear ProSAFE 48-Port Switch",
        "price": "\$899.00",
        "image":
            "https://images.pexels.com/photos/159304/network-cable-ethernet-computer-159304.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.4
      },
      {
        "id": "prod_005",
        "title": "HP Aruba 2930F Switch Series",
        "price": "\$1,850.00",
        "image":
            "https://images.pexels.com/photos/163064/play-stone-network-networked-interactive-163064.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.8
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Gallery
                  ProductImageGallery(
                    images: (_productData['images'] as List).cast<String>(),
                    productTitle: _productData['title'] as String,
                  ),

                  const SizedBox(height: 16),

                  // Product Info Section
                  ProductInfoSection(
                    title: _productData['title'] as String,
                    price: _productData['price'] as String,
                    condition: _productData['condition'] as String,
                    rating: (_productData['rating'] as num).toDouble(),
                    reviewCount: _productData['reviewCount'] as int,
                  ),

                  const SizedBox(height: 16),

                  // Seller Profile Section
                  SellerProfileSection(
                    sellerName: (_productData['seller']
                        as Map<String, dynamic>)['name'] as String,
                    sellerAvatar: (_productData['seller']
                        as Map<String, dynamic>)['avatar'] as String,
                    isVerified: (_productData['seller']
                        as Map<String, dynamic>)['isVerified'] as bool,
                    sellerRating: ((_productData['seller']
                            as Map<String, dynamic>)['rating'] as num)
                        .toDouble(),
                    totalSales: (_productData['seller']
                        as Map<String, dynamic>)['totalSales'] as int,
                    onViewProfile: _viewSellerProfile,
                  ),

                  const SizedBox(height: 24),

                  // Product Description
                  ExpandableDescription(
                    description: _productData['description'] as String,
                  ),

                  const SizedBox(height: 24),

                  // Technical Specifications
                  SpecificationsSection(
                    specifications:
                        (_productData['specifications'] as Map<String, dynamic>)
                            .cast<String, String>(),
                  ),

                  const SizedBox(height: 24),

                  // Shipping & Return Policy
                  ShippingPolicySection(
                    shippingInfo: (_productData['shipping']
                        as Map<String, dynamic>)['info'] as String,
                    returnPolicy: (_productData['shipping']
                        as Map<String, dynamic>)['returnPolicy'] as String,
                    estimatedDelivery: (_productData['shipping']
                        as Map<String, dynamic>)['estimatedDelivery'] as String,
                    shippingCost: (_productData['shipping']
                        as Map<String, dynamic>)['cost'] as String,
                  ),

                  const SizedBox(height: 24),

                  // Related Products
                  RelatedProductsCarousel(
                    relatedProducts: _relatedProducts,
                    onProductTap: _navigateToProduct,
                  ),

                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),

          // Action Buttons Bar
          ActionButtonsBar(
            onContactSeller: _contactSeller,
            onMakeOffer: _makeOffer,
            onSaveProduct: _toggleSaveProduct,
            isSaved: _isSaved,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _shareProduct,
          icon: CustomIconWidget(
            iconName: 'share',
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: _toggleSaveProduct,
          icon: CustomIconWidget(
            iconName: _isSaved ? 'bookmark' : 'bookmark_border',
            color: _isSaved ? colorScheme.primary : colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  void _viewSellerProfile() {
    HapticFeedback.lightImpact();
    // Navigate to seller profile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening seller profile...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _contactSeller() {
    HapticFeedback.lightImpact();
    // Open messaging interface or phone dialer
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildContactOptions(context),
    );
  }

  Widget _buildContactOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Contact Seller',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: colorScheme.primary,
              size: 24,
            ),
            title: Text(
              'Send Message',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Chat with NetworkPro Solutions',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _openMessaging();
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'phone',
              color: colorScheme.primary,
              size: 24,
            ),
            title: Text(
              'Call Seller',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              '+1 (555) 123-4567',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _callSeller();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _openMessaging() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with NetworkPro Solutions...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _callSeller() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling +1 (555) 123-4567...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _makeOffer() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => _buildMakeOfferDialog(context),
    );
  }

  Widget _buildMakeOfferDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController offerController = TextEditingController();

    return AlertDialog(
      title: Text(
        'Make an Offer',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Price: ${_productData['price']}',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: offerController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Your Offer (\$)',
              hintText: 'Enter your offer amount',
              prefixText: '\$ ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _submitOffer(offerController.text);
          },
          child: Text('Submit Offer'),
        ),
      ],
    );
  }

  void _submitOffer(String amount) {
    if (amount.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Offer of \$$amount submitted to seller'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleSaveProduct() {
    HapticFeedback.lightImpact();
    setState(() {
      _isSaved = !_isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved
            ? 'Product saved to favorites'
            : 'Product removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareProduct() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing product...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToProduct(String productId) {
    HapticFeedback.lightImpact();
    // Navigate to another product detail page
    Navigator.pushNamed(context, '/product-detail');
  }
}