import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/friends_to_follow_widget.dart';
import './widgets/post_card_widget.dart';
import './widgets/story_item_widget.dart';
import 'mock_data.dart' show kStories, kPosts, kFriendSuggestions, getUserById, getUserPosts;

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMorePosts = true;
  int _currentBottomIndex = 0;
  final int _unreadMessagesCount =
      3; // mock unread count; replace with real data

  // Use shared mock data to avoid allocating large lists repeatedly.
  final List<Map<String, dynamic>> _stories = kStories;
  final List<Map<String, dynamic>> _posts = kPosts;

  // Mock data for friend suggestions
  final List<Map<String, dynamic>> _friendSuggestions = kFriendSuggestions;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMorePosts) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      // Simulate no more posts after some scrolling
      if (_posts.length > 20) {
        _hasMorePosts = false;
      }
    });
  }

  Future<void> _refreshFeed() async {
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Reset posts and reload
    });
  }

  void _handleStoryTap(Map<String, dynamic> story) {
    HapticFeedback.lightImpact();
    
    // If it's "Your Story", open camera/story creator
    if (story['isOwn'] == true) {
      // Open camera for creating story
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story creator coming soon!')),
      );
      return;
    }

    // Otherwise, navigate to that user's profile/posts
    final userId = story['userId'] as int?;
    if (userId == null) return;

    final user = getUserById(userId);
    if (user == null) return;

    // Navigate to a simple page showing that user's posts
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPostsPage(
          user: user,
          posts: getUserPosts(userId),
        ),
      ),
    );
  }

  void _handlePostLike(Map<String, dynamic> post) {
    HapticFeedback.lightImpact();
    // Handle like action
  }

  void _handlePostComment(Map<String, dynamic> post) {
    HapticFeedback.lightImpact();
    _showCommentsSheet(post);
  }

  void _showCommentsSheet(Map<String, dynamic> post) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> comments = List.generate(
      (post['comments'] as int? ?? 0).clamp(0, 3),
      (i) => {
        'user': 'User ${i + 1}',
        'text': 'This is a sample comment #${i + 1}',
        'replies': i == 0 ? ['Nice!', 'Agreed'] : <String>[],
      },
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final TextEditingController inputCtrl = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollCtrl) {
                return Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Comments (${post['comments'] ?? comments.length})',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Flexible(
                      child: ListView.builder(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.all(16),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final c = comments[index];
                          final replies = c['replies'] as List<String>;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      child: Text(c['user'][0]),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(c['user'],
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                          const SizedBox(height: 2),
                                          Text(c['text'],
                                              style:
                                                  theme.textTheme.bodyMedium),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('Reply'),
                                    ),
                                  ],
                                ),
                                if (replies.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 36),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: replies
                                          .map((r) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .subdirectory_arrow_right,
                                                        size: 16),
                                                    const SizedBox(width: 6),
                                                    Flexible(
                                                        child: Text(r,
                                                            style: theme
                                                                .textTheme
                                                                .bodySmall)),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: inputCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Add a comment...',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              // Mock append
                              if (inputCtrl.text.trim().isEmpty) return;
                              setState(() {
                                post['comments'] =
                                    (post['comments'] as int? ?? 0) + 1;
                              });
                              Navigator.pop(context);
                              // Re-open to reflect change (simple visual update)
                              Future.delayed(const Duration(milliseconds: 100),
                                  () => _showCommentsSheet(post));
                            },
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handlePostShare(Map<String, dynamic> post) {
    HapticFeedback.lightImpact();
    // Handle share action
  }

  void _handlePostSave(Map<String, dynamic> post) {
    HapticFeedback.lightImpact();
    // Handle save action
  }

  void _handlePostReport(Map<String, dynamic> post) {
    HapticFeedback.mediumImpact();
    // Handle report action
    _showReportDialog(post);
  }

  void _showReportDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text(
            'Are you sure you want to report this post? Our team will review it within 24 hours.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post reported successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home Feed
        break;
      case 1:
        Navigator.pushNamed(context, '/education-hub');
        break;
      case 2:
        Navigator.pushNamed(context, '/marketplace');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'people_outline',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'Welcome to Ispilo!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Start connecting with ISP professionals and discover amazing content.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                // Navigate to discover people or create first post
              },
              child: const Text('Find People to Follow'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'Loading more posts...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.standard,
        showNotificationBadge: true,
        notificationCount: 3,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/messages');
            },
            icon: CustomIconWidget(
              iconName: '💬',
              size: 24,
              badgeCount: _unreadMessagesCount,
            ),
          ),
        ],
      ),
      body: _posts.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _refreshFeed,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Stories Section
                  SliverToBoxAdapter(
                    child: Container(
                      height: min(22.h, 180),
                      padding: EdgeInsets.symmetric(vertical: min(2.h, 16)),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: min(4.w, 16)),
                        itemCount: _stories.length,
                        itemBuilder: (context, index) {
                          return StoryItemWidget(
                            story: _stories[index],
                            onTap: () => _handleStoryTap(_stories[index]),
                          );
                        },
                      ),
                    ),
                  ),

                  // Posts Feed
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Insert Friends to Follow widget every 6 posts
                        if (index > 0 &&
                            index % 6 == 0 &&
                            index < _posts.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: FriendsToFollowWidget(
                              suggestions: _friendSuggestions,
                            ),
                          );
                        }

                        final postIndex = index - (index ~/ 6);
                        if (postIndex >= _posts.length) {
                          return _isLoading
                              ? _buildLoadingIndicator()
                              : const SizedBox.shrink();
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: PostCardWidget(
                            post: _posts[postIndex],
                            onLike: () => _handlePostLike(_posts[postIndex]),
                            onComment: () =>
                                _handlePostComment(_posts[postIndex]),
                            onShare: () => _handlePostShare(_posts[postIndex]),
                            onSave: () => _handlePostSave(_posts[postIndex]),
                            onReport: () =>
                                _handlePostReport(_posts[postIndex]),
                          ),
                        );
                      },
                      childCount: _posts.length +
                          (_posts.length ~/ 6) +
                          (_isLoading ? 1 : 0),
                    ),
                  ),

                  // Bottom padding for floating action button
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _handleBottomNavTap,
        variant: CustomBottomBarVariant.standard,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          // Navigate to create post screen
        },
        child: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }
}

// Simple page showing a specific user's posts
class UserPostsPage extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> posts;

  const UserPostsPage({
    super.key,
    required this.user,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1877F2),
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
            ClipOval(
              child: CustomImageWidget(
                imageUrl: user['avatar'] as String,
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
                        user['name'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (user['isVerified'] == true) ...[
                        SizedBox(width: 1.w),
                        const Icon(Icons.verified, color: Colors.white, size: 16),
                      ],
                    ],
                  ),
                  Text(
                    '@${user['username']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: posts.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No posts yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCardWidget(
                  post: posts[index],
                  onLike: () {
                    HapticFeedback.lightImpact();
                  },
                  onComment: () {
                    HapticFeedback.lightImpact();
                  },
                  onShare: () {
                    HapticFeedback.lightImpact();
                  },
                  onSave: () {
                    HapticFeedback.lightImpact();
                  },
                  onReport: () {
                    HapticFeedback.mediumImpact();
                  },
                );
              },
            ),
    );
  }
}
