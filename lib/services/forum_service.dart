import 'package:pregnancy_health_tracker/models/forum_models.dart';

class ForumService {
  // Singleton pattern
  static final ForumService _instance = ForumService._internal();
  factory ForumService() => _instance;
  ForumService._internal();

  // In-memory storage for forum data (would be replaced with Firebase in production)
  final List<ForumCategory> _categories = forumCategories;
  final List<ForumPost> _posts = sampleForumPosts;
  final List<ForumReport> _reports = [];

  // Current user ID (would come from auth service in production)
  final String _currentUserId = 'user1';
  final String _currentUserName = 'Sarah J.';

  // Get current user ID
  String get currentUserId => _currentUserId;
  String get currentUserName => _currentUserName;

  // Get all categories
  List<ForumCategory> getAllCategories() {
    return _categories;
  }

  // Get category by ID
  ForumCategory? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Get all posts
  List<ForumPost> getAllPosts() {
    return _posts.where((post) => post.status == PostStatus.active).toList();
  }

  // Get posts by category
  List<ForumPost> getPostsByCategory(String categoryId) {
    return _posts
        .where((post) =>
            post.categoryId == categoryId && post.status == PostStatus.active)
        .toList();
  }

  // Get post by ID
  ForumPost? getPostById(String postId) {
    try {
      return _posts.firstWhere(
          (post) => post.id == postId && post.status == PostStatus.active);
    } catch (e) {
      return null;
    }
  }

  // Create a new post
  ForumPost createPost({
    required String title,
    required String content,
    required String categoryId,
    List<String> tags = const [],
  }) {
    final newPost = ForumPost(
      id: 'post${_posts.length + 1}',
      userId: _currentUserId,
      userName: _currentUserName,
      title: title,
      content: content,
      createdAt: DateTime.now(),
      categoryId: categoryId,
      tags: tags,
    );

    _posts.add(newPost);
    return newPost;
  }

  // Add a comment to a post
  ForumComment addComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) {
    final post = getPostById(postId);
    if (post == null) {
      throw Exception('Post not found');
    }

    final newComment = ForumComment(
      id: 'comment${post.comments.length + 1}',
      postId: postId,
      userId: _currentUserId,
      userName: _currentUserName,
      content: content,
      createdAt: DateTime.now(),
      parentCommentId: parentCommentId,
    );

    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex >= 0) {
      final updatedComments = List<ForumComment>.from(_posts[postIndex].comments)
        ..add(newComment);
      
      _posts[postIndex] = _posts[postIndex].copyWith(comments: updatedComments);
    }

    return newComment;
  }

  // Add a reaction to a post
  void addReactionToPost({
    required String postId,
    required ReactionType type,
  }) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex < 0) {
      throw Exception('Post not found');
    }

    // Check if user already reacted with this type
    final hasReacted = _posts[postIndex].hasUserReacted(_currentUserId, type);
    
    if (hasReacted) {
      // Remove the reaction if it exists
      final updatedReactions = _posts[postIndex].reactions
          .where((r) => !(r.userId == _currentUserId && r.type == type))
          .toList();
      
      _posts[postIndex] = _posts[postIndex].copyWith(reactions: updatedReactions);
    } else {
      // Add the reaction
      final newReaction = ForumReaction(
        id: 'reaction${_posts[postIndex].reactions.length + 1}',
        userId: _currentUserId,
        userName: _currentUserName,
        type: type,
        createdAt: DateTime.now(),
      );
      
      final updatedReactions = List<ForumReaction>.from(_posts[postIndex].reactions)
        ..add(newReaction);
      
      _posts[postIndex] = _posts[postIndex].copyWith(reactions: updatedReactions);
    }
  }

  // Add a reaction to a comment
  void addReactionToComment({
    required String postId,
    required String commentId,
    required ReactionType type,
  }) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex < 0) {
      throw Exception('Post not found');
    }

    final commentIndex = _posts[postIndex].comments.indexWhere((c) => c.id == commentId);
    if (commentIndex < 0) {
      throw Exception('Comment not found');
    }

    // Check if user already reacted with this type
    final hasReacted = _posts[postIndex].comments[commentIndex].hasUserReacted(_currentUserId, type);
    
    if (hasReacted) {
      // Remove the reaction if it exists
      final updatedReactions = _posts[postIndex].comments[commentIndex].reactions
          .where((r) => !(r.userId == _currentUserId && r.type == type))
          .toList();
      
      final updatedComment = _posts[postIndex].comments[commentIndex].copyWith(
        reactions: updatedReactions,
      );
      
      final updatedComments = List<ForumComment>.from(_posts[postIndex].comments);
      updatedComments[commentIndex] = updatedComment;
      
      _posts[postIndex] = _posts[postIndex].copyWith(comments: updatedComments);
    } else {
      // Add the reaction
      final newReaction = ForumReaction(
        id: 'reaction${_posts[postIndex].comments[commentIndex].reactions.length + 1}',
        userId: _currentUserId,
        userName: _currentUserName,
        type: type,
        createdAt: DateTime.now(),
      );
      
      final updatedReactions = List<ForumReaction>.from(_posts[postIndex].comments[commentIndex].reactions)
        ..add(newReaction);
      
      final updatedComment = _posts[postIndex].comments[commentIndex].copyWith(
        reactions: updatedReactions,
      );
      
      final updatedComments = List<ForumComment>.from(_posts[postIndex].comments);
      updatedComments[commentIndex] = updatedComment;
      
      _posts[postIndex] = _posts[postIndex].copyWith(comments: updatedComments);
    }
  }

  // Report a post or comment
  ForumReport reportContent({
    required String targetId,
    required bool isComment,
    required String reason,
    String? additionalInfo,
  }) {
    final newReport = ForumReport(
      id: 'report${_reports.length + 1}',
      reporterId: _currentUserId,
      reporterName: _currentUserName,
      targetId: targetId,
      isComment: isComment,
      reason: reason,
      additionalInfo: additionalInfo,
      createdAt: DateTime.now(),
    );

    _reports.add(newReport);
    return newReport;
  }

  // Get all reports (for moderators)
  List<ForumReport> getAllReports() {
    return _reports;
  }

  // Resolve a report (for moderators)
  void resolveReport({
    required String reportId,
    required String moderatorAction,
  }) {
    final reportIndex = _reports.indexWhere((r) => r.id == reportId);
    if (reportIndex < 0) {
      throw Exception('Report not found');
    }

    _reports[reportIndex] = _reports[reportIndex].copyWith(
      isResolved: true,
      moderatorId: _currentUserId,
      moderatorAction: moderatorAction,
      resolvedAt: DateTime.now(),
    );

    // If the action is to remove content, update the post or comment status
    if (moderatorAction == 'remove') {
      final report = _reports[reportIndex];
      
      if (report.isComment) {
        // Find and update the comment status
        for (int i = 0; i < _posts.length; i++) {
          final commentIndex = _posts[i].comments.indexWhere((c) => c.id == report.targetId);
          if (commentIndex >= 0) {
            final updatedComment = _posts[i].comments[commentIndex].copyWith(
              status: PostStatus.removed,
            );
            
            final updatedComments = List<ForumComment>.from(_posts[i].comments);
            updatedComments[commentIndex] = updatedComment;
            
            _posts[i] = _posts[i].copyWith(comments: updatedComments);
            break;
          }
        }
      } else {
        // Find and update the post status
        final postIndex = _posts.indexWhere((p) => p.id == report.targetId);
        if (postIndex >= 0) {
          _posts[postIndex] = _posts[postIndex].copyWith(
            status: PostStatus.removed,
          );
        }
      }
    }
  }
}

// Extensions to create copies of objects with updated fields
extension ForumPostExtension on ForumPost {
  ForumPost copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryId,
    List<ForumComment>? comments,
    List<ForumReaction>? reactions,
    PostStatus? status,
    bool? isPinned,
    List<String>? tags,
  }) {
    return ForumPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryId: categoryId ?? this.categoryId,
      comments: comments ?? this.comments,
      reactions: reactions ?? this.reactions,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
    );
  }
}

extension ForumCommentExtension on ForumComment {
  ForumComment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ForumReaction>? reactions,
    PostStatus? status,
    String? parentCommentId,
  }) {
    return ForumComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reactions: reactions ?? this.reactions,
      status: status ?? this.status,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }
}

extension ForumReportExtension on ForumReport {
  ForumReport copyWith({
    String? id,
    String? reporterId,
    String? reporterName,
    String? targetId,
    bool? isComment,
    String? reason,
    String? additionalInfo,
    DateTime? createdAt,
    bool? isResolved,
    String? moderatorId,
    String? moderatorAction,
    DateTime? resolvedAt,
  }) {
    return ForumReport(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      targetId: targetId ?? this.targetId,
      isComment: isComment ?? this.isComment,
      reason: reason ?? this.reason,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      isResolved: isResolved ?? this.isResolved,
      moderatorId: moderatorId ?? this.moderatorId,
      moderatorAction: moderatorAction ?? this.moderatorAction,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
