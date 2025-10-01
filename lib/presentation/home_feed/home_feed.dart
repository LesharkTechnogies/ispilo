import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/friends_to_follow_widget.dart';
import './widgets/post_card_widget.dart';
import './widgets/story_item_widget.dart';

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

  // Mock data for stories
  final List<Map<String, dynamic>> _stories = [
    {
      "id": 1,
      "username": "Your Story",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isViewed": false,
      "isOwn": true,
    },
    {
      "id": 2,
      "username": "alex_network",
      "avatar":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isViewed": false,
    },
    {
      "id": 3,
      "username": "sarah_tech",
      "avatar":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isViewed": true,
    },
    {
      "id": 4,
      "username": "mike_admin",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isViewed": false,
    },
    {
      "id": 5,
      "username": "lisa_isp",
      "avatar":
          "https://images.pexels.com/photos/1239288/pexels-photo-1239288.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isViewed": true,
    },
  ];

  // Mock data for posts
  final List<Map<String, dynamic>> _posts = [
    {
      "id": 1,
      "username": "alex_network",
      "userAvatar":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "timestamp": "2 hours ago",
      "content":
          "Just finished setting up a new fiber network for our community! The speeds are incredible - 1Gbps up and down. ISP life is rewarding when you see the impact on people's daily lives. 🚀",
      "imageUrl":
          "https://images.pexels.com/photos/159304/network-cable-ethernet-computer-159304.jpeg?auto=compress&cs=tinysrgb&w=800",
      "likes": 42,
      "comments": 8,
      "isLiked": false,
      "isSaved": false,
      "isSponsored": false,
      "hasVerification": true,
    },
    {
      "id": 2,
      "username": "sarah_tech",
      "userAvatar":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "timestamp": "4 hours ago",
      "content":
          "Excited to share my latest certification in network security! Always learning and growing in this field. What certifications are you working on?",
      "likes": 28,
      "comments": 12,
      "isLiked": true,
      "isSaved": false,
      "isSponsored": false,
      "hasVerification": false,
    },
    {
      "id": 3,
      "username": "cisco_learning",
      "userAvatar":
          "https://images.pixabay.com/photo/2016/12/27/13/10/logo-1933884_1280.png",
      "timestamp": "6 hours ago",
      "content":
          "Master the fundamentals of network routing and switching with our comprehensive CCNA course. Join thousands of professionals who have advanced their careers.",
      "imageUrl":
          "https://images.pexels.com/photos/1181263/pexels-photo-1181263.jpeg?auto=compress&cs=tinysrgb&w=800",
      "likes": 156,
      "comments": 23,
      "isLiked": false,
      "isSaved": true,
      "isSponsored": true,
      "hasVerification": true,
      "ctaButtons": ["Learn More", "Enroll Now"],
    },
    {
      "id": 4,
      "username": "mike_admin",
      "userAvatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "timestamp": "8 hours ago",
      "content":
          "Server maintenance completed successfully! Zero downtime migration to our new data center. Proud of the team's coordination and planning.",
      "likes": 67,
      "comments": 15,
      "isLiked": false,
      "isSaved": false,
      "isSponsored": false,
      "hasVerification": false,
    },
    {
      "id": 5,
      "username": "lisa_isp",
      "userAvatar":
          "https://images.pexels.com/photos/1239288/pexels-photo-1239288.jpeg?auto=compress&cs=tinysrgb&w=400",
      "timestamp": "10 hours ago",
      "content":
          "Customer satisfaction survey results are in - 98% satisfaction rate! Thank you to everyone who participated. Your feedback helps us improve our services.",
      "likes": 89,
      "comments": 31,
      "isLiked": true,
      "isSaved": false,
      "isSponsored": false,
      "hasVerification": false,
    },
    {
      "id": 6,
      "username": "netgear_pro",
      "userAvatar":
          "https://images.pixabay.com/photo/2017/03/12/02/57/logo-2136735_1280.png",
      "timestamp": "12 hours ago",
      "content":
          "Upgrade your network infrastructure with our latest Wi-Fi 6E routers. Experience blazing fast speeds and reduced latency for your business operations.",
      "imageUrl":
          "https://images.pexels.com/photos/4219654/pexels-photo-4219654.jpeg?auto=compress&cs=tinysrgb&w=800",
      "likes": 203,
      "comments": 45,
      "isLiked": false,
      "isSaved": false,
      "isSponsored": true,
      "hasVerification": true,
      "ctaButtons": ["Shop Now"],
    },
  ];

  // Mock data for friend suggestions
  final List<Map<String, dynamic>> _friendSuggestions = [
    {
      "id": 101,
      "name": "David Chen",
      "avatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Network Engineer",
      "mutualFriends": 5,
    },
    {
      "id": 102,
      "name": "Emma Wilson",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "ISP Manager",
      "mutualFriends": 3,
    },
    {
      "id": 103,
      "name": "James Rodriguez",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "System Admin",
      "mutualFriends": 8,
    },
    {
      "id": 104,
      "name": "Sophie Taylor",
      "avatar":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Tech Support",
      "mutualFriends": 2,
    },
  ];

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
    // Navigate to story viewer or camera for own story
    if (story['isOwn'] == true) {
      // Open camera for creating story
    } else {
      // Open story viewer
    }
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
