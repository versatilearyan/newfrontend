import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';

class LoungeFeedScreen extends StatefulWidget {
  final Lounge lounge;
  const LoungeFeedScreen({super.key, required this.lounge});

  @override
  State<LoungeFeedScreen> createState() => _LoungeFeedScreenState();
}

class _LoungeFeedScreenState extends State<LoungeFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _isJoined = false;
  final _tabs = ['Top', 'New', 'Hot'];

  static const _icons = {
    'Confessions':   Icons.chat_bubble_outline,
    'Romance':       Icons.favorite_outline,
    'General':       Icons.nights_stay_outlined,
    'Career':        Icons.work_outline,
    'Academics':     Icons.school_outlined,
    'Memes':         Icons.sentiment_very_satisfied_outlined,
    'Housing':       Icons.home_outlined,
    'Social':        Icons.people_outline,
    'Wellness':      Icons.self_improvement_outlined,
    'Rants':         Icons.mood_bad_outlined,
    'Entertainment': Icons.music_note_outlined,
    'Sports':        Icons.fitness_center_outlined,
    'Lifestyle':     Icons.style_outlined,
    'Private':       Icons.lock_outline,
  };

  static const _colors = {
    'Confessions':   Color(0xFF0891B2),
    'Romance':       Color(0xFFEC4899),
    'General':       Color(0xFF6366F1),
    'Career':        Color(0xFFD97706),
    'Academics':     Color(0xFF3B5BDB),
    'Memes':         Color(0xFFF97316),
    'Housing':       Color(0xFF059669),
    'Social':        Color(0xFF7C3AED),
    'Wellness':      Color(0xFF14B8A6),
    'Rants':         Color(0xFFEF4444),
    'Entertainment': Color(0xFF8B5CF6),
    'Sports':        Color(0xFF16A34A),
    'Lifestyle':     Color(0xFFDB2777),
    'Private':       Color(0xFF374151),
  };

  IconData get _icon  => _icons[widget.lounge.category] ?? Icons.tag;
  Color    get _color => _colors[widget.lounge.category] ?? AppTheme.primary;

  List<Post> get _posts {
    final name = widget.lounge.name.toLowerCase();
    final matched = samplePosts.where((p) =>
        (p.lounge?.toLowerCase().contains(name) ?? false) ||
        (p.university?.toLowerCase().contains(name) ?? false)).toList();
    return matched.isEmpty ? samplePosts : matched;
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _toggleJoin() {
    HapticFeedback.mediumImpact();
    setState(() => _isJoined = !_isJoined);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isJoined
          ? '✅ Joined ${widget.lounge.name}'
          : 'Left ${widget.lounge.name}'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: _isJoined ? AppTheme.primary : const Color(0xFF6B7280),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ));
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000)    return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final lounge = widget.lounge;

    return Scaffold(
      backgroundColor: context.bgPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen())),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.edit_outlined, color: Colors.white),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            // Banner height = 200, pinned appbar = 56, avatar overlap = 40
            expandedHeight: 310,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: context.bgSurface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,

            // ── Back + actions always visible ───────────────────────────
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(
                        color: Colors.black38, shape: BoxShape.circle),
                    child: const Icon(Icons.search,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: GestureDetector(
                  onTap: () => _showOptions(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(
                        color: Colors.black38, shape: BoxShape.circle),
                    child: const Icon(Icons.more_horiz,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _LoungeHeader(
                lounge: lounge,
                isJoined: _isJoined,
                onJoin: _toggleJoin,
                icon: _icon,
                color: _color,
                fmt: _fmt,
              ),
            ),

            // ── Tab bar pinned below header ──────────────────────────────
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: Container(
                color: context.bgSurface,
                child: TabBar(
                  controller: _tabCtrl,
                  labelColor: AppTheme.primary,
                  unselectedLabelColor: context.txtSub,
                  indicatorColor: AppTheme.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: _tabs.map((_) => _PostFeed(
                posts: _posts,
                lounge: lounge,
              )).toList(),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        decoration: BoxDecoration(
            color: context.bgCard,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: context.border,
                  borderRadius: BorderRadius.circular(2)),
            ),
            _Opt(icon: Icons.notifications_outlined, label: 'Mute lounge',
                onTap: () => Navigator.pop(context)),
            _Opt(icon: Icons.bookmark_border, label: 'Save lounge',
                onTap: () => Navigator.pop(context)),
            _Opt(icon: Icons.share_outlined, label: 'Share lounge',
                onTap: () => Navigator.pop(context)),
            _Opt(icon: Icons.flag_outlined, label: 'Report lounge',
                color: AppTheme.red, onTap: () => Navigator.pop(context)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Header widget — banner + avatar + info + join button ──────────────────────
class _LoungeHeader extends StatelessWidget {
  final Lounge lounge;
  final bool isJoined;
  final VoidCallback onJoin;
  final IconData icon;
  final Color color;
  final String Function(int) fmt;

  const _LoungeHeader({
    required this.lounge,
    required this.isJoined,
    required this.onJoin,
    required this.icon,
    required this.color,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    const double bannerH  = 180;
    const double avatarSz = 72;
    const double avatarOverlap = 30; // how much avatar sticks above surface

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Banner + avatar overlap (Stack) ──────────────────────────
        SizedBox(
          height: bannerH + avatarSz - avatarOverlap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover photo
              Positioned(
                top: 0, left: 0, right: 0,
                height: bannerH,
                child: lounge.imageUrl != null
                    ? Image.network(
                        lounge.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return _FallbackBanner(color: color);
                        },
                        errorBuilder: (_, __, ___) =>
                            _FallbackBanner(color: color),
                      )
                    : _FallbackBanner(color: color),
              ),

              // Dark gradient at bottom of banner for readability
              Positioned(
                left: 0, right: 0,
                top: bannerH - 60,
                height: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        context.bgSurface.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // Surface background below banner
              Positioned(
                left: 0, right: 0,
                top: bannerH,
                bottom: 0,
                child: Container(color: context.bgSurface),
              ),

              // Avatar — centered on the banner/surface seam
              Positioned(
                left: 16,
                top: bannerH - avatarOverlap,
                child: Container(
                  width: avatarSz,
                  height: avatarSz,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: context.bgSurface, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: lounge.profileImageUrl != null
                        ? Image.network(
                            lounge.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(icon, color: color, size: 32),
                            ),
                            loadingBuilder: (_, child, prog) =>
                                prog == null ? child : Center(
                                  child: Icon(icon, color: color, size: 32),
                                ),
                          )
                        : Center(child: Icon(icon, color: color, size: 32)),
                  ),
                ),
              ),

              // Join button — right-aligned, vertically centred with avatar
              Positioned(
                right: 16,
                top: bannerH - avatarOverlap + (avatarSz / 2) - 20,
                child: GestureDetector(
                  onTap: onJoin,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: isJoined
                          ? Colors.transparent
                          : AppTheme.primary,
                      borderRadius: BorderRadius.circular(24),
                      border: isJoined
                          ? Border.all(color: color.withOpacity(0.4))
                          : null,
                    ),
                    child: Text(
                      isJoined ? 'Joined' : 'Join',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isJoined ? context.txtMain : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Name + info below the overlap ─────────────────────────────
        Container(
          color: context.bgSurface,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lounge name
              Text(
                lounge.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: context.txtMain,
                ),
              ),
              const SizedBox(height: 5),
              // Public · followers · posts
              Row(
                children: [
                  Icon(Icons.public, size: 14, color: context.txtSub),
                  const SizedBox(width: 4),
                  Text('Public',
                      style: TextStyle(
                          fontSize: 13, color: context.txtSub)),
                  Text('  ·  ',
                      style:
                          TextStyle(fontSize: 13, color: context.txtLight)),
                  Text('${fmt(lounge.members)} Followers',
                      style: TextStyle(
                          fontSize: 13,
                          color: context.txtSub,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 10),
                  Icon(Icons.bolt_outlined,
                      size: 13, color: context.txtLight),
                  const SizedBox(width: 3),
                  Text('${lounge.posts}/wk',
                      style:
                          TextStyle(fontSize: 13, color: context.txtSub)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Fallback gradient banner (when no image / loading fails) ──────────────────
class _FallbackBanner extends StatelessWidget {
  final Color color;
  const _FallbackBanner({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

// ── Post feed ─────────────────────────────────────────────────────────────────
class _PostFeed extends StatelessWidget {
  final List<Post> posts;
  final Lounge lounge;
  const _PostFeed({required this.posts, required this.lounge});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article_outlined, size: 48, color: context.txtLight),
            const SizedBox(height: 12),
            Text('No posts yet',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.txtSub)),
            const SizedBox(height: 6),
            Text('Be the first to post in ${lounge.name}',
                style:
                    TextStyle(fontSize: 13, color: context.txtLight)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: posts.length,
      itemBuilder: (ctx, i) {
        final p = posts[i];
        return PostCard(
          post: p,
          onTap: () => Navigator.push(ctx,
              MaterialPageRoute(builder: (_) => PostDetailScreen(post: p))),
        );
      },
    );
  }
}

// ── Bottom sheet option ───────────────────────────────────────────────────────
class _Opt extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _Opt(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.txtMain;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: c),
            const SizedBox(width: 14),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c)),
          ],
        ),
      ),
    );
  }
}