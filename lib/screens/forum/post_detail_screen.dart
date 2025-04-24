import 'package:flutter/material.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:pregnancy_health_tracker/models/forum_models.dart';
import 'package:pregnancy_health_tracker/services/forum_service.dart';
import 'package:pregnancy_health_tracker/utils/fade_animation.dart';
import 'package:pregnancy_health_tracker/widgets/forum_comment_card.dart';
import 'package:intl/intl.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ForumService _forumService = ForumService();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ForumPost? _post;
  ForumCategory? _category;
  bool _isLoading = true;
  bool _isSubmittingComment = false;

  void _scrollToCommentField() {
    // Wait for the UI to update
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        // Scroll to the bottom
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

        // Focus the comment field
        FocusScope.of(context).requestFocus(_commentFocusNode);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  void _loadPost() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _post = _forumService.getPostById(widget.postId);
        if (_post != null) {
          _category = _forumService.getCategoryById(_post!.categoryId);
        }
        _isLoading = false;
      });
    });
  }

  void _addReaction(ReactionType type) {
    if (_post == null) return;

    setState(() {
      _forumService.addReactionToPost(
        postId: _post!.id,
        type: type,
      );
      _loadPost(); // Reload post to get updated reactions
    });
  }

  void _submitComment() {
    if (_post == null) return;

    // Validate comment
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a comment'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      try {
        _forumService.addComment(
          postId: _post!.id,
          content: _commentController.text.trim(),
        );

        setState(() {
          _commentController.clear();
          _isSubmittingComment = false;
        });

        _loadPost(); // Reload post to get updated comments
      } catch (e) {
        setState(() {
          _isSubmittingComment = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding comment: ${e.toString()}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  void _showReportDialog() {
    if (_post == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you reporting this post?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildReportOption('Inappropriate content'),
            _buildReportOption('Harassment or bullying'),
            _buildReportOption('Misinformation'),
            _buildReportOption('Spam'),
            _buildReportOption('Other'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(String reason) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);

        // Submit report
        _forumService.reportContent(
          targetId: _post!.id,
          isComment: false,
          reason: reason,
        );

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your report. Our moderators will review it.'),
            duration: Duration(seconds: 3),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.flag_outlined, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(reason),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isLoading || _post == null
            ? const Text(
                'Post Details',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                _category?.title ?? 'Post Details',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          if (!_isLoading && _post != null)
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.flag_outlined, color: Colors.red),
                          title: const Text('Report Post'),
                          onTap: () {
                            Navigator.pop(context);
                            _showReportDialog();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.share_outlined),
                          title: const Text('Share Post'),
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sharing will be implemented soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _post == null
              ? _buildPostNotFound()
              : Column(
                  children: [
                    // Post content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Post header
                            FadeAnimation(
                              delay: 0.1,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(13),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title and category
                                    Text(
                                      _post!.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Author and date
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.grey[300],
                                          child: _post!.userAvatar != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: Image.asset(
                                                    _post!.userAvatar!,
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Text(
                                                        _post!.userName.substring(0, 1),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Text(
                                                  _post!.userName.substring(0, 1),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _post!.userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '• ${DateFormat.yMMMd().format(_post!.createdAt)}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Content
                                    Text(
                                      _post!.content,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Tags
                                    if (_post!.tags.isNotEmpty)
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: _post!.tags.map((tag) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor.withAlpha(25),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    const SizedBox(height: 16),

                                    // Reactions and comments count
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _post!.reactionCount.toString(),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${_post!.commentCount} comments',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 24),

                                    // Reaction buttons (Facebook-like)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildReactionButton(
                                            icon: _post!.hasUserReacted(
                                              _forumService.currentUserId,
                                              ReactionType.like,
                                            ) ? Icons.thumb_up : Icons.thumb_up_outlined,
                                            label: 'Like',
                                            isActive: _post!.hasUserReacted(
                                              _forumService.currentUserId,
                                              ReactionType.like,
                                            ),
                                            onTap: () => _addReaction(ReactionType.like),
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildReactionButton(
                                            icon: Icons.chat_bubble_outline,
                                            label: 'Comment',
                                            isActive: false,
                                            onTap: () {
                                              // Scroll to comment field and focus it
                                              _scrollToCommentField();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildReactionButton(
                                            icon: Icons.share_outlined,
                                            label: 'Share',
                                            isActive: false,
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Sharing will be implemented soon!'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Comments section
                            FadeAnimation(
                              delay: 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Comments (${_post!.commentCount})',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Comments list
                                  if (_post!.comments.isEmpty)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.chat_bubble_outline,
                                              size: 48,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'No comments yet',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Be the first to comment!',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _post!.comments.length,
                                      itemBuilder: (context, index) {
                                        final comment = _post!.comments[index];
                                        return FadeAnimation(
                                          delay: 0.3 + (index * 0.05),
                                          child: ForumCommentCard(
                                            comment: comment,
                                            onLike: () {
                                              setState(() {
                                                _forumService.addReactionToComment(
                                                  postId: _post!.id,
                                                  commentId: comment.id,
                                                  type: ReactionType.like,
                                                );
                                                _loadPost(); // Reload post to get updated reactions
                                              });
                                            },
                                            onReport: () {
                                              // Show report dialog for comment
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Report Comment'),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        'Why are you reporting this comment?',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 16),
                                                      _buildReportOption('Inappropriate content'),
                                                      _buildReportOption('Harassment or bullying'),
                                                      _buildReportOption('Misinformation'),
                                                      _buildReportOption('Spam'),
                                                      _buildReportOption('Other'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text('Cancel'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Comment input
                    FadeAnimation(
                      delay: 0.4,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey[300],
                              child: Text(
                                _forumService.currentUserName.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                focusNode: _commentFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Add a comment...',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                minLines: 1,
                                maxLines: 3,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _isSubmittingComment
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: _submitComment,
                                    icon: const Icon(Icons.send),
                                    color: AppColors.primaryColor,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPostNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Post not found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The post may have been removed or deleted',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.primaryColor : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
