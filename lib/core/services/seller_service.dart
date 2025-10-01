import 'dart:async';
import '../models/seller.dart';

/// Simple seller service. Replace internals with real DB/API calls as needed.
class SellerService {
  SellerService._internal();

  static final SellerService instance = SellerService._internal();

  // Mock in-memory sellers map
  final Map<String, Seller> _sellers = {
    'seller_001': Seller(
      id: 'seller_001',
      name: 'NetworkPro Solutions',
      avatar:
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=200',
      isVerified: true,
      phone: '+15551234567',
      phonePrivacyPublic: true,
      countryCode: '254',
    ),
  };

  Future<Seller?> getSellerById(String id) async {
    // simulate network/db delay
    await Future.delayed(const Duration(milliseconds: 200));
    return _sellers[id];
  }

  Future<void> saveSeller(Seller seller) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _sellers[seller.id] = seller;
  }

  /// Create or update a seller from a loosely typed map (e.g. product payload)
  Future<Seller> upsertSellerFromMap(Map<String, dynamic> m) async {
    final id = m['id'] as String? ??
        m['sellerId'] as String? ??
        'seller_${DateTime.now().millisecondsSinceEpoch}';
    final seller = Seller(
      id: id,
      name: m['name'] as String? ?? m['sellerName'] as String? ?? 'Seller',
      avatar: m['avatar'] as String? ?? m['sellerAvatar'] as String? ?? '',
      isVerified: m['isVerified'] as bool? ?? false,
      phone: m['phone'] as String? ?? m['sellerPhone'] as String?,
      phonePrivacyPublic: m['phonePrivacyPublic'] as bool? ??
          m['isPhonePublic'] as bool? ??
          false,
      countryCode:
          m['countryCode'] as String? ?? m['sellerCountryCode'] as String?,
    );

    await saveSeller(seller);
    return seller;
  }

  /// Return all sellers (useful for debugging/testing)
  Future<List<Seller>> listSellers() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _sellers.values.toList();
  }
}
