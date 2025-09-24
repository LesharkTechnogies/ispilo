import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundFadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _splashDuration = Duration(seconds: 3);
  static const Duration _timeoutDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Background fade animation
    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startSplashSequence() async {
    try {
      // Start background fade
      _fadeAnimationController.forward();

      // Small delay then start logo animation
      await Future.delayed(const Duration(milliseconds: 300));
      _logoAnimationController.forward();

      // Initialize app services with timeout
      await Future.any([
        _initializeAppServices(),
        Future.delayed(_timeoutDuration, () => throw TimeoutException()),
      ]);

      // Wait for minimum splash duration
      await Future.delayed(_splashDuration);

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError();
      }
    }
  }

  Future<void> _initializeAppServices() async {
    try {
      // Simulate checking authentication status
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate loading user preferences
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulate fetching essential configuration
      await Future.delayed(const Duration(milliseconds: 700));

      // Simulate preparing cached social feed data
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      throw Exception('Failed to initialize app services');
    }
  }

  void _handleInitializationError() {
    setState(() {
      _hasError = true;
    });

    if (_retryCount < _maxRetries) {
      // Show retry option after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showRetryDialog();
        }
      });
    } else {
      // Max retries reached, show error state
      _showErrorState();
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Connection Error',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Unable to connect to Ispilo services. Please check your internet connection and try again.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retryInitialization();
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToOfflineMode();
            },
            child: const Text('Continue Offline'),
          ),
        ],
      ),
    );
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _retryCount++;
    });
    _startSplashSequence();
  }

  void _showErrorState() {
    // Navigate to offline mode or show persistent error
    _navigateToOfflineMode();
  }

  void _navigateToNextScreen() {
    // Determine navigation path based on user state
    // For demo purposes, navigating to home feed
    // In real app, this would check authentication status
    Navigator.pushReplacementNamed(context, '/home-feed');
  }

  void _navigateToOfflineMode() {
    // Navigate to limited functionality mode
    Navigator.pushReplacementNamed(context, '/home-feed');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide system status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundFadeAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary.withValues(
                    alpha: _backgroundFadeAnimation.value,
                  ),
                  AppTheme.lightTheme.colorScheme.primaryContainer.withValues(
                    alpha: _backgroundFadeAnimation.value * 0.8,
                  ),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Opacity(
                              opacity: _logoFadeAnimation.value,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // App logo
                                  Container(
                                    width: min(120.w, 120),
                                    height: min(120.w, 120),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(min(24.w, 24)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'I',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: min(48.sp, 48),
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  // App name
                                  Text(
                                    'Ispilo',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: min(32.sp, 32),
                                          letterSpacing: 2,
                                        ),
                                  ),
                                  SizedBox(height: 1.h),
                                  // Tagline
                                  Text(
                                    'Connect • Learn • Trade',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                          fontSize: min(16.sp, 16),
                                          letterSpacing: 1,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Loading section
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_hasError) ...[
                            // Error state
                            CustomIconWidget(
                              iconName: 'error_outline',
                              color: Colors.white,
                              size: 32.w,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Connection Error',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Retrying... (${_retryCount}/$_maxRetries)',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ] else ...[
                            // Loading state
                            SizedBox(
                              width: 32.w,
                              height: 32.w,
                              child: CircularProgressIndicator(
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                strokeWidth: 3,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              _isInitialized
                                  ? 'Ready to connect!'
                                  : 'Initializing...',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14.sp,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Bottom section with version info
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Column(
                      children: [
                        Text(
                          'ISP Community Platform',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12.sp,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Version 1.0.0',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 10.sp,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom exception for timeout handling
class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Operation timed out']);

  @override
  String toString() => 'TimeoutException: $message';
}
