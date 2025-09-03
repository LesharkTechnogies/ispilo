import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class StoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> story;
  final VoidCallback? onTap;

  const StoryItemWidget({
    super.key,
    required this.story,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isViewed = story['isViewed'] as bool? ?? false;
    final comments = story['comments'] as int? ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 3.w),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: min(16.w, 64),
                  height: min(16.w, 64),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isViewed
                        ? null
                        : LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.tertiary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    color: isViewed
                        ? theme.colorScheme.outline.withValues(alpha: 0.3)
                        : null,
                  ),
                  padding: EdgeInsets.all(min(0.5.w, 2)),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: story['avatar'] as String? ?? '',
                        width: min(14.w, 56),
                        height: min(14.w, 56),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (comments > 0)
                  Positioned(
                    bottom: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble,
                              size: 10, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            comments.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 1.h),
            SizedBox(
              width: min(16.w, 64),
              child: Text(
                story['username'] as String? ?? '',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
