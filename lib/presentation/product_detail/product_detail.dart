import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/seller_service.dart';
import '../../core/services/conversation_service.dart';

import '../../core/app_export.dart';
import '../../core/models/seller.dart';
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
  bool _loading = false;
  String? _hudError;
  VoidCallback? _hudRetryAction;
  late Map<String, dynamic> _productData;
  late List<Map<String, dynamic>> _relatedProducts;

  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() {
      _loading = value;
      if (value) _hudError = null; // clear previous error when starting
    });
  }

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
        // Phone details: number and privacy flag (true = public)
        "phone": "+15551234567",
        // Country code to use for WhatsApp or local numbers (no plus)
        "countryCode": "254",
        "phonePrivacyPublic": true,
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
      body: Stack(
        children: [
          Column(
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
                        specifications: (_productData['specifications']
                                as Map<String, dynamic>)
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
                                as Map<String, dynamic>)['estimatedDelivery']
                            as String,
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
          if (_loading || _hudError != null)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: _hudError == null
                      ? Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator()),
                                SizedBox(width: 12),
                                Text('Please wait...'),
                              ],
                            ),
                          ),
                        )
                      : Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_hudError!,
                                    style:
                                        const TextStyle(color: Colors.black87)),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // cancel
                                        setState(() {
                                          _hudError = null;
                                        });
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        // retry
                                        setState(() {
                                          _hudError = null;
                                        });
                                        if (_hudRetryAction != null)
                                          _hudRetryAction!.call();
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
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
            onTap: () async {
              Navigator.pop(context);
              await _openMessagingWithSeller();
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'whatsapp',
              color: const Color(0xFF25D366), // WhatsApp green
              size: 24,
            ),
            title: Text(
              'WhatsApp',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Chat via WhatsApp',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              await _openWhatsAppWithSeller();
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
            onTap: () async {
              Navigator.pop(context);
              await _callSellerWithSeller();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _openMessagingWithSeller() async {
    _setLoading(true);

    // Try to upsert seller from product payload (will use existing id if present)
    final productSellerMap =
        (_productData['seller'] as Map<String, dynamic>?) ?? {};
    // Prefer explicit seller id if present
    String? explicitSellerId = productSellerMap['id'] as String?;
    Seller seller;
    if (explicitSellerId != null && explicitSellerId.isNotEmpty) {
      final existing =
          await SellerService.instance.getSellerById(explicitSellerId);
      if (existing != null) {
        seller = existing;
      } else {
        // upsert using provided id and other fields
        productSellerMap['id'] = explicitSellerId;
        seller =
            await SellerService.instance.upsertSellerFromMap(productSellerMap);
      }
    } else {
      seller =
          await SellerService.instance.upsertSellerFromMap(productSellerMap);
      explicitSellerId = seller.id;
    }

    _setLoading(false);

    final conversation =
        await ConversationService.instance.getOrCreateConversation(
      sellerId: seller.id,
      sellerName: seller.name,
      sellerAvatar: seller.avatar,
    );

    Navigator.pushNamed(context, AppRoutes.chat, arguments: conversation);
  }

  Future<void> _callSellerWithSeller() async {
    _setLoading(true);

    final productSellerMap =
        (_productData['seller'] as Map<String, dynamic>?) ?? {};
    String? explicitSellerId = productSellerMap['id'] as String?;
    Seller seller;
    if (explicitSellerId != null && explicitSellerId.isNotEmpty) {
      final existing =
          await SellerService.instance.getSellerById(explicitSellerId);
      seller = existing ??
          await SellerService.instance.upsertSellerFromMap(productSellerMap);
    } else {
      seller =
          await SellerService.instance.upsertSellerFromMap(productSellerMap);
    }

    final rawPhone = seller.phone ?? '';
    final isPublic = seller.phonePrivacyPublic;

    if (rawPhone.isEmpty) {
      _setLoading(false);
      setState(() {
        _hudError = 'Seller phone number not available.';
        _hudRetryAction = () => _callSellerWithSeller();
      });
      return;
    }

    if (!isPublic) {
      _setLoading(false);
      setState(() {
        _hudError = 'Seller phone number is private.';
        _hudRetryAction = () => _callSellerWithSeller();
      });
      return;
    }

    final normalized = _normalizePhone(rawPhone, seller.countryCode);

    _setLoading(false); // clear HUD before showing confirmation

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Seller'),
        content: Text('Call $normalized?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final uri = Uri(scheme: 'tel', path: normalized);
              launchUrl(uri);
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  Future<void> _openWhatsAppWithSeller() async {
    _setLoading(true);

    final productSellerMap =
        (_productData['seller'] as Map<String, dynamic>?) ?? {};
    String? explicitSellerId = productSellerMap['id'] as String?;
    Seller seller;
    if (explicitSellerId != null && explicitSellerId.isNotEmpty) {
      final existing =
          await SellerService.instance.getSellerById(explicitSellerId);
      seller = existing ??
          await SellerService.instance.upsertSellerFromMap(productSellerMap);
    } else {
      seller =
          await SellerService.instance.upsertSellerFromMap(productSellerMap);
    }

    final rawPhone = seller.phone ?? '';
    final isPublic = seller.phonePrivacyPublic;

    if (rawPhone.isEmpty) {
      _setLoading(false);
      setState(() {
        _hudError = 'Seller phone number not available.';
        _hudRetryAction = () => _openWhatsAppWithSeller();
      });
      return;
    }

    if (!isPublic) {
      _setLoading(false);
      setState(() {
        _hudError = 'Seller phone number is private.';
        _hudRetryAction = () => _openWhatsAppWithSeller();
      });
      return;
    }

    final normalized = _normalizePhone(rawPhone, seller.countryCode);
    final uri = Uri.parse('https://wa.me/$normalized');

    _setLoading(false);

    // show confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open WhatsApp'),
        content: Text('Open WhatsApp chat with $normalized?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (!await canLaunchUrl(uri)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open WhatsApp.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  String _normalizePhone(String raw, String? countryCode) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final cc = (countryCode ?? '254').replaceAll(RegExp(r'[^0-9]'), '');
    // If digits already looks like an international number (starts with country code), return as-is.
    if (digits.length >= 10) return digits;
    // Otherwise prefix country code
    return '$cc$digits';
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

    // Find the related product data
    final relatedProduct = _relatedProducts.firstWhere(
      (product) => product['id'] == productId,
      orElse: () => <String, dynamic>{},
    );

    if (relatedProduct.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product not found'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Create full product data from related product
    final fullProductData = _createFullProductData(relatedProduct);

    // Navigate to product detail with full data
    Navigator.pushNamed(context, '/product-detail', arguments: fullProductData);
  }

  Map<String, dynamic> _createFullProductData(Map<String, dynamic> relatedProduct) {
    final productId = relatedProduct['id'] as String;

    // Create mock full product data based on the product ID
    // In a real app, this would fetch from an API
    switch (productId) {
      case 'prod_002':
        return {
          "title": "Cisco ASA 5506-X Firewall",
          "price": "\$1,250.00",
          "condition": "New",
          "rating": 4.7,
          "reviewCount": 23,
          "images": [
            "https://images.pexels.com/photos/442150/pexels-photo-442150.jpeg?auto=compress&cs=tinysrgb&w=400",
            "https://images.pexels.com/photos/442151/pexels-photo-442151.jpeg?auto=compress&cs=tinysrgb&w=400"
          ],
          "seller": {
            "id": "seller_002",
            "name": "SecureNet Solutions",
            "avatar": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=400",
            "isVerified": true,
            "rating": 4.8,
            "totalSales": 156
          },
          "description": "Advanced firewall security appliance with next-generation features including application visibility and control, multiple security services, and flexible VPN capabilities.",
          "specifications": {
            "Model": "ASA 5506-X",
            "Throughput": "750 Mbps",
            "VPN Peers": "50",
            "Interfaces": "8 x 1GbE",
            "Security Contexts": "2"
          },
          "shipping": {
            "info": "Ships within 1-2 business days",
            "estimatedDelivery": "3-5 business days",
            "cost": "Free shipping",
            "returnPolicy": "30-day return policy. Items must be in original condition with all accessories. Return shipping costs are covered by seller for defective items."
          }
        };

      case 'prod_003':
        return {
          "title": "Ubiquiti UniFi Switch 24-Port",
          "price": "\$379.00",
          "condition": "New",
          "rating": 4.6,
          "reviewCount": 45,
          "images": [
            "https://images.pexels.com/photos/325229/pexels-photo-325229.jpeg?auto=compress&cs=tinysrgb&w=400",
            "https://images.pexels.com/photos/325230/pexels-photo-325230.jpeg?auto=compress&cs=tinysrgb&w=400"
          ],
          "seller": {
            "id": "seller_003",
            "name": "NetworkPro Solutions",
            "avatar": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=400",
            "isVerified": true,
            "rating": 4.7,
            "totalSales": 89
          },
          "description": "Managed Gigabit switch with 24 ports, featuring auto-sensing Gigabit Ethernet, PoE+ support, and UniFi Controller management.",
          "specifications": {
            "Model": "US-24-250W",
            "Ports": "24 x 1GbE",
            "PoE Budget": "250W",
            "Switching Capacity": "52 Gbps",
            "Forwarding Rate": "38.69 Mpps"
          },
          "shipping": {
            "info": "Ships within 1-2 business days",
            "estimatedDelivery": "3-5 business days",
            "cost": "Free shipping",
            "returnPolicy": "30-day return policy. Items must be in original condition with all accessories."
          }
        };

      case 'prod_004':
        return {
          "title": "Netgear ProSAFE 48-Port Switch",
          "price": "\$899.00",
          "condition": "Like New",
          "rating": 4.4,
          "reviewCount": 31,
          "images": [
            "https://images.pexels.com/photos/159304/network-cable-ethernet-computer-159304.jpeg?auto=compress&cs=tinysrgb&w=400",
            "https://images.pexels.com/photos/159305/network-cable-ethernet-computer-159305.jpeg?auto=compress&cs=tinysrgb&w=400"
          ],
          "seller": {
            "id": "seller_004",
            "name": "TechHub Networks",
            "avatar": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=400",
            "isVerified": false,
            "rating": 4.2,
            "totalSales": 67
          },
          "description": "Enterprise-grade managed switch with 48 Gigabit ports, advanced security features, and comprehensive management capabilities.",
          "specifications": {
            "Model": "GS748T",
            "Ports": "48 x 1GbE + 4 x SFP",
            "Switching Capacity": "96 Gbps",
            "MAC Address Table": "16K",
            "Jumbo Frame Support": "9KB"
          },
          "shipping": {
            "info": "Ships within 2-3 business days",
            "estimatedDelivery": "4-6 business days",
            "cost": "\$25.00",
            "returnPolicy": "14-day return policy for unopened items."
          }
        };

      case 'prod_005':
        return {
          "title": "HP Aruba 2930F Switch Series",
          "price": "\$1,850.00",
          "condition": "New",
          "rating": 4.8,
          "reviewCount": 18,
          "images": [
            "https://images.pexels.com/photos/163064/play-stone-network-networked-interactive-163064.jpeg?auto=compress&cs=tinysrgb&w=400",
            "https://images.pexels.com/photos/163065/play-stone-network-networked-interactive-163065.jpeg?auto=compress&cs=tinysrgb&w=400"
          ],
          "seller": {
            "id": "seller_005",
            "name": "Enterprise Networks Inc",
            "avatar": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=400",
            "isVerified": true,
            "rating": 4.9,
            "totalSales": 203
          },
          "description": "High-performance managed switch with advanced Layer 3 features, PoE support, and Aruba's innovative management interface.",
          "specifications": {
            "Model": "JL253A",
            "Ports": "24 x 1GbE + 4 x 1GbE/SFP",
            "PoE Budget": "370W",
            "Switching Capacity": "88 Gbps",
            "Latency": "< 3.8 μs"
          },
          "shipping": {
            "info": "Ships within 1-2 business days",
            "estimatedDelivery": "3-5 business days",
            "cost": "Free shipping",
            "returnPolicy": "30-day return policy with full refund for defective items."
          }
        };

      default:
        // Fallback product data
        return {
          "title": relatedProduct['title'] ?? 'Unknown Product',
          "price": relatedProduct['price'] ?? '\$0.00',
          "condition": "Unknown",
          "rating": relatedProduct['rating'] ?? 0.0,
          "reviewCount": 0,
          "images": [relatedProduct['image'] ?? ''],
          "seller": {
            "id": "seller_unknown",
            "name": "Unknown Seller",
            "avatar": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=400",
            "isVerified": false,
            "rating": 0.0,
            "totalSales": 0
          },
          "description": "Product description not available.",
          "specifications": {},
          "shipping": {
            "info": "Shipping information not available",
            "estimatedDelivery": "TBD",
            "cost": "TBD",
            "returnPolicy": "Standard return policy applies."
          }
        };
    }
  }
}
