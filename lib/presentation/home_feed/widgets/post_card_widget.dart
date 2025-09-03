import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostCardWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onReport;

  const PostCardWidget({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
    this.onReport,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool isLiked = false;
  bool isSaved = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post['isLiked'] as bool? ?? false;
    isSaved = widget.post['isSaved'] as bool? ?? false;
    likeCount = widget.post['likes'] as int? ?? 0;
  }

  void _handleLike() {
    HapticFeedback.lightImpact();
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });
    widget.onLike?.call();
  }

  void _handleSave() {
    HapticFeedback.lightImpact();
    setState(() {
      isSaved = !isSaved;
    });
    widget.onSave?.call();
  }

  void _showQuickActions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Share Post'),
              onTap: () {
                Navigator.pop(context);
                widget.onShare?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_border',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(isSaved ? 'Remove from Saved' : 'Save Post'),
              onTap: () {
                Navigator.pop(context);
                _handleSave();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
                widget.onReport?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSponsored = widget.post['isSponsored'] as bool? ?? false;
    final hasVerification = widget.post['hasVerification'] as bool? ?? false;

    return GestureDetector(
      onLongPress: _showQuickActions,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  ClipOval(
                    child: CustomImageWidget(
                      imageUrl: widget.post['userAvatar'] as String? ?? '',
                      width: 10.w,
                      height: 10.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.post['username'] as String? ?? '',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (hasVerification) ...[
                              SizedBox(width: 1.w),
                              CustomIconWidget(
                                iconName: 'verified',
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          widget.post['timestamp'] as String? ?? '',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (isSponsored) ...[
                          SizedBox(height: 0.5.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Sponsored',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showQuickActions,
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Post Content
            if (widget.post['content'] != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  widget.post['content'] as String,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Post Image/Video
            if (widget.post['imageUrl'] != null) ...[
              CustomImageWidget(
                imageUrl: widget.post['imageUrl'] as String,
                width: double.infinity,
                height: 50.h,
                fit: BoxFit.cover,
              ),
            ],

            // Interaction Bar
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _handleLike,
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName:
                                  isLiked ? 'favorite' : 'favorite_border',
                              color: isLiked
                                  ? Colors.red
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                              size: 24,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              likeCount.toString(),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: widget.onComment,
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'chat_bubble_outline',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 24,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              (widget.post['comments'] as int? ?? 0).toString(),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: widget.onShare,
                        child: CustomIconWidget(
                          iconName: 'share',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _handleSave,
                        child: CustomIconWidget(
                          iconName: isSaved ? 'bookmark' : 'bookmark_border',
                          color: isSaved
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          size: 24,
                        ),
                      ),
                    ],
                  ),

                  // CTA Buttons for Sponsored Posts
                  if (isSponsored && widget.post['ctaButtons'] != null) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        for (final cta
                            in (widget.post['ctaButtons'] as List)) ...[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                // Handle CTA action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                cta as String,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          if (cta != (widget.post['ctaButtons'] as List).last)
                            SizedBox(width: 2.w),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
