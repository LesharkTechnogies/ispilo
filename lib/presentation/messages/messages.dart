import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_image_widget.dart';
import '../chat/chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data for conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "name": "Sarah Chen",
      "avatar":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "Thanks for the network diagram! It really helped with our setup.",
      "timestamp": "2m",
      "isOnline": true,
      "unreadCount": 2,
      "isVerified": true,
    },
    {
      "id": 2,
      "name": "Mike Rodriguez",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "Can we schedule a call tomorrow about the router configuration?",
      "timestamp": "15m",
      "isOnline": false,
      "unreadCount": 0,
      "isVerified": false,
    },
    {
      "id": 3,
      "name": "Tech Support Team",
      "avatar":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "Your support ticket has been resolved. Let us know if you need further assistance.",
      "timestamp": "1h",
      "isOnline": false,
      "unreadCount": 0,
      "isVerified": true,
    },
    {
      "id": 4,
      "name": "Alex Network",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "Just shared the latest fiber optic installation photos in the group!",
      "timestamp": "3h",
      "isOnline": true,
      "unreadCount": 1,
      "isVerified": false,
    },
    {
      "id": 5,
      "name": "Jennifer Park",
      "avatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "The wireless deployment went smoothly. Thanks for your guidance!",
      "timestamp": "5h",
      "isOnline": false,
      "unreadCount": 0,
      "isVerified": true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleConversationTap(Map<String, dynamic> conversation) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(conversation: conversation),
      ),
    );
  }

  void _handleNewMessage() {
    HapticFeedback.lightImpact();
    // Navigate to contacts or new message screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1877F2),
        elevation: 1,
        title: Text(
          'Messages',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleNewMessage,
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Search Bar
          Container(
            margin: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey[600],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.2.h,
                ),
              ),
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),

          // Active Status Bar
          Container(
            height: 10.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _conversations.where((c) => c['isOnline']).length,
              itemBuilder: (context, index) {
                final onlineUsers =
                    _conversations.where((c) => c['isOnline']).toList();
                final user = onlineUsers[index];

                return Container(
                  margin: EdgeInsets.only(right: 3.w),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: CustomImageWidget(
                              imageUrl: user['avatar'],
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 3.w,
                              height: 3.w,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        user['name'].split(' ')[0],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Divider(
            height: 0.5.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Conversations List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                final hasUnread = conversation['unreadCount'] > 0;

                return Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () => _handleConversationTap(conversation),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.2.h,
                    ),
                    leading: Stack(
                      children: [
                        ClipOval(
                          child: CustomImageWidget(
                            imageUrl: conversation['avatar'],
                            width: 14.w,
                            height: 14.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (conversation['isOnline'])
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF00D84A), // WhatsApp green
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation['name'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight:
                                  hasUnread ? FontWeight.w600 : FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation['isVerified']) ...[
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF1877F2),
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: Text(
                        conversation['lastMessage'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: hasUnread ? Colors.black54 : Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          conversation['timestamp'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: hasUnread
                                ? const Color(0xFF1877F2)
                                : Colors.grey[500],
                            fontWeight:
                                hasUnread ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        if (hasUnread) ...[
                          SizedBox(height: 0.8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.4.h,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1877F2),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation['unreadCount'].toString(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }
}
