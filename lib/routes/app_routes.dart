import 'package:flutter/material.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/marketplace/marketplace.dart';
import '../presentation/education_hub/education_hub.dart';
import '../presentation/home_feed/home_feed.dart';
import '../presentation/settings/settings.dart';
import '../presentation/settings/edit_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String productDetail = '/product-detail';
  static const String splash = '/splash-screen';
  static const String marketplace = '/marketplace';
  static const String educationHub = '/education-hub';
  static const String homeFeed = '/home-feed';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    productDetail: (context) => const ProductDetail(),
    splash: (context) => const SplashScreen(),
    marketplace: (context) => const Marketplace(),
    educationHub: (context) => const EducationHub(),
    homeFeed: (context) => const HomeFeed(),
    settings: (context) => const Settings(),
    editProfile: (context) => const EditProfile(),
    // TODO: Add your other routes here
  };
}
