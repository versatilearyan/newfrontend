// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _replyCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _postLiked = false;
  bool _postBookmarked = false;
  late int _postLikeCount;

  String? _replyingToId;
  String? _replyingToName;

  late List<_CState> _comments;

  @override
  void initState() {
    super.initState();
    _postLikeCount = widget.post.likes;
    _comments = sampleComments(widget.post.id)
        .map((c) => _CState.from(c))
        .toList();
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startReply(String commentId, String username) {
    setState(() {
      _replyingToId = commentId;
      _replyingToName = username;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingToId = null;
      _replyingToName = null;
    });
    _focusNode.unfocus();
  }

  void _submit() {
    final text = _replyCtrl.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();

    final newC = _CState(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      username: 'You',
      avatarColor: AppTheme.primary,
      avatarInitials: 'Y',
      content: text,
      timeAgo: 'just now',
      likes: 0,
    );

    setState(() {
      if (_replyingToId != null) {
        for (final c in _comments) {
          if (c.id == _replyingToId) {
            c.replies.add(newC);
            c.showReplies = true;
            break;
          }
        }
      } else {
        _comments.add(newC);
      }
      _replyingToId = null;
      _replyingToName = null;
    });

    _replyCtrl.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    final totalComments =
        _comments.fold(0, (s, c) => s + 1 + c.replies.length);

    return Scaffold(
      backgroundColor: context.bgPage,
      appBar: AppBar(
        backgroundColor: context.bgSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.txtMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          p.lounge != null ? '#${p.lounge}' : 'Post',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.txtMain),
        ),
        actions: [
          IconButton(
              icon:
                  Icon(Icons.ios_share_rounded, color: context.txtMain, size: 20),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                // ── Full post ─────────────────────────────────────────────
                _FullPost(
                  post: p,
                  liked: _postLiked,
                  likeCount: _postLikeCount,
                  bookmarked: _postBookmarked,
                  onLike: () => setState(() {
                    _postLiked = !_postLiked;
                    _postLikeCount += _postLiked ? 1 : -1;
                  }),
                  onBookmark: () =>
                      setState(() => _postBookmarked = !_postBookmarked),
                  onReply: () {
                    _replyingToId = null;
                    _replyingToName = null;
                    _focusNode.requestFocus();
                  },
                ),

                // ── Comment count ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Row(
                    children: [
                      Text('$totalComments Comments',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: context.txtMain)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Sort: Top',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),

                // ── Comment list ──────────────────────────────────────────
                ..._comments.expand((c) => [
                      _CommentTile(
                        state: c,
                        isReply: false,
                        onLike: () => setState(() {
                          c.isLiked = !c.isLiked;
                          c.likes += c.isLiked ? 1 : -1;
                        }),
                        onReply: () => _startReply(c.id, c.username),
                        onToggleReplies: () =>
                            setState(() => c.showReplies = !c.showReplies),
                      ),
                      if (c.showReplies)
                        ...c.replies.map((r) => _CommentTile(
                              state: r,
                              isReply: true,
                              onLike: () => setState(() {
                                r.isLiked = !r.isLiked;
                                r.likes += r.isLiked ? 1 : -1;
                              }),
                              onReply: () => _startReply(c.id, r.username),
                              onToggleReplies: () {},
                            )),
                    ]),
              ],
            ),
          ),

          // ── Comment input bar ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: context.bgSurface,
              border:
                  Border(top: BorderSide(color: context.border, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Replying-to strip
                  if (_replyingToName != null)
                    Container(
                      width: double.infinity,
                      color: AppTheme.primary.withOpacity(0.08),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.reply, size: 13, color: AppTheme.primary),
                          const SizedBox(width: 6),
                          Text('Replying to @$_replyingToName',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w500)),
                          const Spacer(),
                          GestureDetector(
                            onTap: _cancelReply,
                            child: Icon(Icons.close,
                                size: 15, color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  // Text + send
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Row(
                      children: [
                        AnonAvatar(
                            size: 34, initials: 'Y', bg: AppTheme.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: context.bgPage,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: context.border),
                            ),
                            child: TextField(
                              controller: _replyCtrl,
                              focusNode: _focusNode,
                              style: TextStyle(
                                  fontSize: 13.5, color: context.txtMain),
                              decoration: InputDecoration(
                                hintText: _replyingToName != null
                                    ? 'Reply to @$_replyingToName...'
                                    : 'Add a comment...',
                                hintStyle: TextStyle(
                                    fontSize: 13.5, color: context.txtLight),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _submit(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle),
                            child: const Icon(Icons.send_rounded,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Full post widget ──────────────────────────────────────────────────────────
class _FullPost extends StatelessWidget {
  final Post post;
  final bool liked;
  final int likeCount;
  final bool bookmarked;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  final VoidCallback onReply;

  const _FullPost({
    required this.post,
    required this.liked,
    required this.likeCount,
    required this.bookmarked,
    required this.onLike,
    required this.onBookmark,
    required this.onReply,
  });

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final p = post;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name + university + time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnonAvatar(size: 44, initials: p.avatarInitials, bg: p.avatarColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(p.username,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: context.txtMain)),
                        if (p.university != null) ...[
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: p.avatarColor.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(p.university!,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: p.avatarColor)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(p.timeAgo,
                            style: TextStyle(
                                fontSize: 12, color: context.txtLight)),
                        if (p.lounge != null) ...[
                          Text(' · ',
                              style: TextStyle(
                                  fontSize: 12, color: context.txtLight)),
                          Text('#${p.lounge}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: context.txtSub,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Title
          if (p.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(p.title!,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: context.txtMain,
                      height: 1.3)),
            ),

          // Full content (no maxLines clamp)
          Text(p.content,
              style: TextStyle(
                  fontSize: 15, color: context.txtSub, height: 1.6)),

          const SizedBox(height: 16),
          Divider(color: context.border, height: 0.5, thickness: 0.5),
          const SizedBox(height: 12),

          // Action row
          Row(
            children: [
              _Btn(
                icon: liked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: liked ? Colors.red : context.txtLight,
                label: _fmt(likeCount),
                labelColor: liked ? Colors.red : context.txtLight,
                bold: liked,
                onTap: onLike,
              ),
              const SizedBox(width: 20),
              _Btn(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: context.txtLight,
                label: _fmt(post.comments),
                labelColor: context.txtLight,
                onTap: onReply,
              ),
              const SizedBox(width: 20),
              _Btn(
                icon: Icons.ios_share_rounded,
                iconColor: context.txtLight,
                label: 'Share',
                labelColor: context.txtLight,
                onTap: () {},
              ),
              const Spacer(),
              GestureDetector(
                onTap: onBookmark,
                child: Icon(
                  bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 22,
                  color: bookmarked ? AppTheme.primary : context.txtLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final bool bold;
  final VoidCallback onTap;

  const _Btn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.onTap,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      color: labelColor,
                      fontWeight:
                          bold ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      );
}

// ── Mutable comment state ─────────────────────────────────────────────────────
class _CState {
  final String id;
  final String username;
  final Color avatarColor;
  final String avatarInitials;
  final String? university;
  final String content;
  final String timeAgo;
  int likes;
  bool isLiked;
  List<_CState> replies;
  bool showReplies;

  _CState({
    required this.id,
    required this.username,
    required this.avatarColor,
    required this.avatarInitials,
    this.university,
    required this.content,
    required this.timeAgo,
    required this.likes,
    this.isLiked = false,
    List<_CState>? replies,
    this.showReplies = false,
  }) : replies = replies ?? [];

  factory _CState.from(Comment c) => _CState(
        id: c.id,
        username: c.username,
        avatarColor: c.avatarColor,
        avatarInitials: c.avatarInitials,
        university: c.university,
        content: c.content,
        timeAgo: c.timeAgo,
        likes: c.likes,
        replies: c.replies.map(_CState.from).toList(),
      );
}

// ── Comment tile ──────────────────────────────────────────────────────────────
class _CommentTile extends StatelessWidget {
  final _CState state;
  final bool isReply;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onToggleReplies;

  const _CommentTile({
    required this.state,
    this.isReply = false,
    required this.onLike,
    required this.onReply,
    required this.onToggleReplies,
  });

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 56 : 16,
        right: 16,
        top: 10,
        bottom: 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thread line for replies
          if (isReply)
            Container(
              width: 2,
              height: 36,
              margin: const EdgeInsets.only(right: 10, top: 4),
              decoration: BoxDecoration(
                color: context.border,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

          AnonAvatar(
            size: isReply ? 30 : 36,
            initials: state.avatarInitials,
            bg: state.avatarColor,
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + university + time
                Row(
                  children: [
                    Text(state.username,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: context.txtMain)),
                    if (state.university != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: state.avatarColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(state.university!,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: state.avatarColor)),
                      ),
                    ],
                    const Spacer(),
                    Text(state.timeAgo,
                        style:
                            TextStyle(fontSize: 11, color: context.txtLight)),
                  ],
                ),
                const SizedBox(height: 4),

                // Comment content
                Text(state.content,
                    style: TextStyle(
                        fontSize: 14,
                        color: context.txtMain,
                        height: 1.45)),
                const SizedBox(height: 8),

                // Like · Reply · show replies
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              state.isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 15,
                              color:
                                  state.isLiked ? Colors.red : context.txtLight,
                            ),
                            const SizedBox(width: 4),
                            Text(_fmt(state.likes),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: state.isLiked
                                        ? Colors.red
                                        : context.txtLight,
                                    fontWeight: state.isLiked
                                        ? FontWeight.w700
                                        : FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onReply,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(Icons.reply, size: 15, color: context.txtLight),
                            const SizedBox(width: 4),
                            Text('Reply',
                                style: TextStyle(
                                    fontSize: 12, color: context.txtLight)),
                          ],
                        ),
                      ),
                    ),
                    if (!isReply && state.replies.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onToggleReplies,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            state.showReplies
                                ? 'Hide replies'
                                : '↳  ${state.replies.length} ${state.replies.length == 1 ? 'reply' : 'replies'}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Divider(color: context.border, height: 1, thickness: 0.4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}