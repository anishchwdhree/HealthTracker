import 'package:flutter/material.dart';

enum ForumCategoryType {
  generalDiscussion,
  menstrualHealth,
  pregnancy,
  fertility,
  parentingSupport,
  healthAndWellness,
}

class ForumCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final ForumCategoryType type;
  final int postCount;

  ForumCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
    this.postCount = 0,
  });
}

enum PostStatus {
  active,
  underReview,
  removed,
}

class ForumPost {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String categoryId;
  final List<ForumComment> comments;
  final List<ForumReaction> reactions;
  final PostStatus status;
  final bool isPinned;
  final List<String> tags;

  ForumPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.categoryId,
    this.comments = const [],
    this.reactions = const [],
    this.status = PostStatus.active,
    this.isPinned = false,
    this.tags = const [],
  });

  // Get comment count
  int get commentCount => comments.length;

  // Get reaction count
  int get reactionCount => reactions.length;

  // Get like count
  int get likeCount => reactions.where((r) => r.type == ReactionType.like).length;

  // Check if user has reacted
  bool hasUserReacted(String userId, ReactionType type) {
    return reactions.any((r) => r.userId == userId && r.type == type);
  }
}

class ForumComment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ForumReaction> reactions;
  final PostStatus status;
  final String? parentCommentId; // For nested comments

  ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.reactions = const [],
    this.status = PostStatus.active,
    this.parentCommentId,
  });

  // Get reaction count
  int get reactionCount => reactions.length;

  // Get like count
  int get likeCount => reactions.where((r) => r.type == ReactionType.like).length;

  // Check if user has reacted
  bool hasUserReacted(String userId, ReactionType type) {
    return reactions.any((r) => r.userId == userId && r.type == type);
  }
}

enum ReactionType {
  like,
  heart,
  support,
  helpful,
}

class ForumReaction {
  final String id;
  final String userId;
  final String userName;
  final ReactionType type;
  final DateTime createdAt;

  ForumReaction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.createdAt,
  });
}

// Report model for moderation
class ForumReport {
  final String id;
  final String reporterId;
  final String reporterName;
  final String targetId; // Can be post ID or comment ID
  final bool isComment; // Whether the target is a comment
  final String reason;
  final String? additionalInfo;
  final DateTime createdAt;
  final bool isResolved;
  final String? moderatorId;
  final String? moderatorAction;
  final DateTime? resolvedAt;

  ForumReport({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.targetId,
    required this.isComment,
    required this.reason,
    this.additionalInfo,
    required this.createdAt,
    this.isResolved = false,
    this.moderatorId,
    this.moderatorAction,
    this.resolvedAt,
  });
}

// Sample data for forum categories
List<ForumCategory> forumCategories = [
  ForumCategory(
    id: 'general',
    title: 'General Discussion',
    description: 'Discuss any topics related to women\'s health and wellness.',
    icon: Icons.forum,
    color: Colors.blue.shade400,
    type: ForumCategoryType.generalDiscussion,
    postCount: 42,
  ),
  ForumCategory(
    id: 'menstrual',
    title: 'Menstrual Health',
    description: 'Discuss period symptoms, cycle tracking, and menstrual products.',
    icon: Icons.calendar_today,
    color: Colors.red.shade400,
    type: ForumCategoryType.menstrualHealth,
    postCount: 78,
  ),
  ForumCategory(
    id: 'pregnancy',
    title: 'Pregnancy',
    description: 'Share experiences and ask questions about pregnancy.',
    icon: Icons.pregnant_woman,
    color: Colors.purple.shade400,
    type: ForumCategoryType.pregnancy,
    postCount: 56,
  ),
  ForumCategory(
    id: 'fertility',
    title: 'Fertility & Trying to Conceive',
    description: 'Support and advice for those trying to conceive.',
    icon: Icons.favorite,
    color: Colors.pink.shade400,
    type: ForumCategoryType.fertility,
    postCount: 34,
  ),
  ForumCategory(
    id: 'parenting',
    title: 'Parenting Support',
    description: 'Connect with other parents and share your journey.',
    icon: Icons.child_care,
    color: Colors.green.shade400,
    type: ForumCategoryType.parentingSupport,
    postCount: 29,
  ),
  ForumCategory(
    id: 'wellness',
    title: 'Health & Wellness',
    description: 'Discuss nutrition, exercise, mental health, and self-care.',
    icon: Icons.spa,
    color: Colors.teal.shade400,
    type: ForumCategoryType.healthAndWellness,
    postCount: 47,
  ),
];

// Sample data for forum posts
List<ForumPost> sampleForumPosts = [
  ForumPost(
    id: 'post1',
    userId: 'user1',
    userName: 'Sarah J.',
    userAvatar: 'assets/images/forum/avatar1.png',
    title: 'Tips for managing period cramps?',
    content: '''
I've been experiencing really bad cramps lately and over-the-counter pain relievers aren't helping much. Does anyone have any natural remedies or other suggestions that have worked for them?

I've tried heating pads and they help a little, but I'm looking for more solutions. Thanks in advance for your help!
''',
    createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    categoryId: 'menstrual',
    comments: [
      ForumComment(
        id: 'comment1',
        postId: 'post1',
        userId: 'user2',
        userName: 'Emily R.',
        userAvatar: 'assets/images/forum/avatar2.png',
        content: 'I find that gentle yoga specifically designed for period pain helps me a lot. There are some great videos on YouTube!',
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        reactions: [
          ForumReaction(
            id: 'reaction1',
            userId: 'user1',
            userName: 'Sarah J.',
            type: ReactionType.helpful,
            createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
          ),
          ForumReaction(
            id: 'reaction2',
            userId: 'user3',
            userName: 'Jessica T.',
            type: ReactionType.like,
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 22)),
          ),
        ],
      ),
      ForumComment(
        id: 'comment2',
        postId: 'post1',
        userId: 'user4',
        userName: 'Mia L.',
        userAvatar: 'assets/images/forum/avatar3.png',
        content: 'Magnesium supplements have been a game-changer for me. I take them regularly throughout my cycle, not just during my period. Always check with your doctor before starting any supplements though!',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 18)),
        reactions: [
          ForumReaction(
            id: 'reaction3',
            userId: 'user1',
            userName: 'Sarah J.',
            type: ReactionType.helpful,
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 16)),
          ),
        ],
      ),
    ],
    reactions: [
      ForumReaction(
        id: 'reaction4',
        userId: 'user2',
        userName: 'Emily R.',
        type: ReactionType.support,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      ),
      ForumReaction(
        id: 'reaction5',
        userId: 'user5',
        userName: 'Olivia W.',
        type: ReactionType.like,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      ),
    ],
    tags: ['Period Pain', 'Cramps', 'Remedies'],
  ),
  ForumPost(
    id: 'post2',
    userId: 'user6',
    userName: 'Sophia K.',
    userAvatar: 'assets/images/forum/avatar4.png',
    title: 'First pregnancy - what should I expect in the first trimester?',
    content: '''
I just found out I'm pregnant with my first child (about 5 weeks along)! I'm excited but also nervous as I don't know what to expect. 

What were your experiences in the first trimester? Any tips for managing morning sickness or fatigue? What symptoms should I watch out for?

Thank you all in advance for sharing your wisdom!
''',
    createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 12)),
    categoryId: 'pregnancy',
    comments: [
      ForumComment(
        id: 'comment3',
        postId: 'post2',
        userId: 'user7',
        userName: 'Ava P.',
        userAvatar: 'assets/images/forum/avatar5.png',
        content: 'Congratulations! The first trimester can be tough with fatigue and nausea. Small, frequent meals helped me with morning sickness. Also, don\'t be afraid to rest when you need to - your body is doing a lot of work!',
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        reactions: [
          ForumReaction(
            id: 'reaction6',
            userId: 'user6',
            userName: 'Sophia K.',
            type: ReactionType.helpful,
            createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 9)),
          ),
        ],
      ),
    ],
    reactions: [
      ForumReaction(
        id: 'reaction7',
        userId: 'user8',
        userName: 'Isabella C.',
        type: ReactionType.heart,
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 11)),
      ),
      ForumReaction(
        id: 'reaction8',
        userId: 'user9',
        userName: 'Emma B.',
        type: ReactionType.support,
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
      ),
      ForumReaction(
        id: 'reaction9',
        userId: 'user10',
        userName: 'Charlotte D.',
        type: ReactionType.support,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 20)),
      ),
    ],
    tags: ['First Pregnancy', 'First Trimester', 'Morning Sickness'],
  ),
  ForumPost(
    id: 'post3',
    userId: 'user11',
    userName: 'Amelia G.',
    userAvatar: 'assets/images/forum/avatar6.png',
    title: 'Tracking ovulation - which methods work best?',
    content: '''
My partner and I have been trying to conceive for a few months now. I've been using ovulation predictor kits, but I'm wondering if there are other methods I should be trying as well.

Has anyone had success with basal body temperature tracking or cervical mucus monitoring? Any apps you'd recommend for tracking fertility signs?

Thanks for any insights you can share!
''',
    createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 7)),
    categoryId: 'fertility',
    comments: [
      ForumComment(
        id: 'comment4',
        postId: 'post3',
        userId: 'user12',
        userName: 'Harper S.',
        userAvatar: 'assets/images/forum/avatar7.png',
        content: 'I used a combination of BBT and cervical mucus tracking, along with OPKs. The Fertility Friend app was really helpful for seeing patterns. It took us 6 months, but we just got our positive test last week!',
        createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 5)),
        reactions: [
          ForumReaction(
            id: 'reaction10',
            userId: 'user11',
            userName: 'Amelia G.',
            type: ReactionType.heart,
            createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 4)),
          ),
        ],
      ),
    ],
    reactions: [
      ForumReaction(
        id: 'reaction11',
        userId: 'user13',
        userName: 'Evelyn M.',
        type: ReactionType.like,
        createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
      ),
      ForumReaction(
        id: 'reaction12',
        userId: 'user14',
        userName: 'Abigail F.',
        type: ReactionType.helpful,
        createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 22)),
      ),
    ],
    tags: ['TTC', 'Ovulation', 'Fertility Tracking'],
  ),
];
