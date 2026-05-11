import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ── University Tag ─────────────────────────────────────────────────────────────
class UniversityTag extends StatelessWidget {
  final String name;
  final Color? color;
  const UniversityTag({super.key, required this.name, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (color ?? AppTheme.primary).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color ?? AppTheme.primary,
        ),
      ),
    );
  }
}

// ── Lounge Tag ─────────────────────────────────────────────────────────────────
class LoungeTag extends StatelessWidget {
  final String name;
  const LoungeTag({super.key, required this.name});

  static const _colors = {
    'Academics':   Color(0xFF3B5BDB),
    'Social':      Color(0xFF7C3AED),
    'Housing':     Color(0xFF059669),
    'Career':      Color(0xFFD97706),
    'Rants':       Color(0xFFDC2626),
    'Memes':       Color(0xFFF97316),
    'Confessions': Color(0xFF0891B2),
    'General':     Color(0xFF6B7280),
  };

  @override
  Widget build(BuildContext context) {
    final c = _colors[name] ?? AppTheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(name,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c)),
    );
  }
}

// ── Anon Avatar ────────────────────────────────────────────────────────────────
class AnonAvatar extends StatelessWidget {
  final double size;
  final String initials;
  final Color? bg;
  const AnonAvatar({super.key, this.size = 40, this.initials = 'A', this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg ?? AppTheme.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }
}

// ── POST CARD ─────────────────────────────────────────────────────────────────
// Matches the screenshot: avatar · username · university pill · time · #channel
// Bold title · body text · likes · comments · share · bookmark
class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  bool _liked = false;
  bool _bookmarked = false;
  late int _likeCount;

  late AnimationController _heartCtrl;
  late AnimationController _burstCtrl;
  late Animation<double> _heartScale;
  late Animation<double> _burstScale;
  late Animation<double> _burstOpacity;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;

    _heartCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _burstCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));

    _heartScale = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.5)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.5, end: 0.9)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 30),
      TweenSequenceItem(
          tween: Tween(begin: 0.9, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 30),
    ]).animate(_heartCtrl);

    _burstScale = Tween(begin: 0.3, end: 1.6)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_burstCtrl);

    _burstOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.8), weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 0.8, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 40),
    ]).animate(_burstCtrl);
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    _burstCtrl.dispose();
    super.dispose();
  }

  void _toggleLike() {
    HapticFeedback.lightImpact();
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
    if (_liked) {
      _heartCtrl.forward(from: 0);
      _burstCtrl.forward(from: 0);
    } else {
      _heartCtrl.forward(from: 0);
    }
  }

  void _toggleBookmark() {
    HapticFeedback.lightImpact();
    setState(() => _bookmarked = !_bookmarked);
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnonAvatar(size: 42, initials: p.avatarInitials, bg: p.avatarColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // username + university pill
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            p.username,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: context.txtMain,
                            ),
                          ),
                          if (p.university != null) ...[
                            const SizedBox(width: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: p.avatarColor.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                p.university!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: p.avatarColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      // time · #channel
                      Row(
                        children: [
                          Text(p.timeAgo,
                              style: TextStyle(
                                  fontSize: 12, color: context.txtLight)),
                          if (p.lounge != null) ...[
                            Text(' · ',
                                style: TextStyle(
                                    fontSize: 12, color: context.txtLight)),
                            Text(
                              '#${p.lounge}',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.txtSub,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // ⋯ more
                GestureDetector(
                  onTap: () => _showOptions(context, p),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),
                    child: Icon(Icons.more_horiz,
                        size: 20, color: context.txtLight),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 11),

            // ── Bold title ────────────────────────────────────────────────
            if (p.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  p.title!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: context.txtMain,
                    height: 1.3,
                  ),
                ),
              ),

            // ── Body text ─────────────────────────────────────────────────
            Text(
              p.content,
              maxLines: p.title != null ? 3 : 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: context.txtSub,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 14),

            // ── Action row ────────────────────────────────────────────────
            Row(
              children: [
                // ♡ Like
                _Tap(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _burstCtrl,
                            builder: (_, __) => Opacity(
                              opacity: _burstOpacity.value,
                              child: Transform.scale(
                                scale: _burstScale.value,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.4),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _heartCtrl,
                            builder: (_, __) => Transform.scale(
                              scale: _heartCtrl.isAnimating
                                  ? _heartScale.value
                                  : 1.0,
                              child: Icon(
                                _liked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 20,
                                color:
                                    _liked ? Colors.red : context.txtLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _liked
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _liked ? Colors.red : context.txtLight,
                        ),
                        child: Text(_fmt(_likeCount)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // 💬 Comments
                _Tap(
                  onTap: widget.onTap,
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          size: 19, color: context.txtLight),
                      const SizedBox(width: 5),
                      Text(
                        _fmt(p.comments),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.txtLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Share
                _Tap(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('🔗 Link copied'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 2),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    ));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.ios_share_rounded,
                          size: 18, color: context.txtLight),
                      const SizedBox(width: 5),
                      Text('Share',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: context.txtLight,
                          )),
                    ],
                  ),
                ),

                const Spacer(),

                // Bookmark
                _Tap(
                  onTap: _toggleBookmark,
                  child: Icon(
                    _bookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 20,
                    color:
                        _bookmarked ? AppTheme.primary : context.txtLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, Post p) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final opts = [
          (Icons.thumb_up_alt_outlined,   'Show more like this',       AppTheme.primary,        false),
          (Icons.thumb_down_alt_outlined, 'Show less like this',       const Color(0xFF6B7280), false),
          (Icons.send_outlined,           'Send via DM',               AppTheme.primary,        false),
          (Icons.flag_outlined,           'Report post',               const Color(0xFFD97706), false),
          (Icons.block,                   'Block posts from this user', const Color(0xFFDC2626), true),
        ];
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          decoration: BoxDecoration(
              color: context.bgCard,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: context.border,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Row(
                  children: [
                    AnonAvatar(size: 26, initials: p.avatarInitials, bg: p.avatarColor),
                    const SizedBox(width: 8),
                    Text(p.username,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.txtMain)),
                    const Spacer(),
                    Text('Post options',
                        style: TextStyle(fontSize: 12, color: context.txtLight)),
                  ],
                ),
              ),
              Divider(height: 0.5, thickness: 0.5, color: context.border),
              ...opts.map((o) => InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: o.$3.withOpacity(o.$4 ? 0.12 : 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(o.$1, size: 18, color: o.$3),
                          ),
                          const SizedBox(width: 14),
                          Text(o.$2,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: o.$4 ? o.$3 : context.txtMain)),
                          const Spacer(),
                          Icon(Icons.chevron_right,
                              size: 16, color: context.txtLight),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

// ── Tap helper ────────────────────────────────────────────────────────────────
class _Tap extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  const _Tap({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: child),
      );
}

// ── Bottom Nav Bar ────────────────────────────────────────────────────────────
class CampusBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CampusBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined,       Icons.home_rounded,    'Feed'),
      (Icons.explore_outlined,    Icons.explore_rounded, 'Lounges'),
      (Icons.add_circle_outline,  Icons.add_circle,      'Post'),
      (Icons.chat_bubble_outline, Icons.chat_bubble,     'DMs'),
      (Icons.person_outline,      Icons.person_rounded,  'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.bgSurface,
        border: Border(top: BorderSide(color: context.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final item = items[i];
              final active = i == currentIndex;
              if (i == 2) {
                return GestureDetector(
                  onTap: () => onTap(i),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                        color: AppTheme.primary, shape: BoxShape.circle),
                    child:
                        const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                );
              }
              return GestureDetector(
                onTap: () => onTap(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(active ? item.$2 : item.$1,
                        color: active ? AppTheme.primary : context.txtLight,
                        size: 24),
                    const SizedBox(height: 2),
                    Text(item.$3,
                        style: TextStyle(
                          fontSize: 10,
                          color: active ? AppTheme.primary : context.txtLight,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}