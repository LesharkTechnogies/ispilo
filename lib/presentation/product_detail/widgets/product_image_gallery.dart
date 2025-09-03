import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final String productTitle;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.productTitle,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 85.w,
      width: double.infinity,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              HapticFeedback.lightImpact();
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _openFullScreenGallery(context, index),
                child: Hero(
                  tag: 'product_image_$index',
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: widget.images[index],
                        width: double.infinity,
                        height: 85.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Page Indicators
          if (widget.images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentIndex ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

          // Full Screen Button
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () => _openFullScreenGallery(context, _currentIndex),
                icon: CustomIconWidget(
                  iconName: 'fullscreen',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreenGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenGallery(
          images: widget.images,
          initialIndex: initialIndex,
          productTitle: widget.productTitle,
        ),
      ),
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String productTitle;

  const _FullScreenGallery({
    required this.images,
    required this.initialIndex,
    required this.productTitle,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareImage,
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
        title: Text(
          '${_currentIndex + 1} of ${widget.images.length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _transformationController.value = Matrix4.identity();
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            transformationController: _transformationController,
            minScale: 1.0,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: 'product_image_$index',
                child: CustomImageWidget(
                  imageUrl: widget.images[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _shareImage() {
    // Share functionality would be implemented here
    HapticFeedback.lightImpact();
  }
}