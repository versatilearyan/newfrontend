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

  List<Post> get _posts {
    final name = widget.lounge.name.toLowerCase();
    final matched = samplePosts
        .where((p) =>
            (p.lounge?.toLowerCase().contains(name) ?? false) ||
            (p.university?.toLowerCase().contains(name) ?? false))
        .toList();
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
    HapticFeedback.lightImpact();
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
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  Color _categoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'academics': return const Color(0xFF3B5BDB);
      case 'social':    return const Color(0xFF7C3AED);
      case 'sports':    return const Color(0xFF059669);
      case 'career':    return const Color(0xFFD97706);
      case 'housing':   return const Color(0xFF0891B2);
      case 'rants':     return const Color(0xFFDC2626);
      case 'private':   return const Color(0xFF374151);
      default:          return AppTheme.primary;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'academics': return Icons.school_outlined;
      case 'social':    return Icons.people_outline;
      case 'sports':    return Icons.sports_outlined;
      case 'career':    return Icons.work_outline;
      case 'housing':   return Icons.home_outlined;
      case 'rants':     return Icons.mood_bad_outlined;
      case 'private':   return Icons.lock_outline;
      default:          return Icons.tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lounge = widget.lounge;
    final catColor = _categoryColor(lounge.category);

    return Scaffold(
      backgroundColor: context.bgPage,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: context.bgSurface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.txtMain),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.search, color: context.txtMain),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.more_horiz, color: context.txtMain),
                  onPressed: () => _showChannelOptions(context)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                color: context.bgSurface,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64, height: 64,
                              decoration: BoxDecoration(
                                color: catColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: catColor.withOpacity(0.3), width: 1),
                              ),
                              child: Center(
                                child: Icon(_categoryIcon(lounge.category),
                                    color: catColor, size: 30),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lounge.name,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: context.txtMain)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: catColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(lounge.category,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: catColor,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _toggleJoin,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isJoined
                                      ? context.bgCard
                                      : AppTheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: _isJoined
                                      ? Border.all(color: context.border)
                                      : null,
                                ),
                                child: Text(
                                  _isJoined ? 'Joined' : 'Join',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _isJoined
                                        ? context.txtMain
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _StatChip(
                                icon: Icons.people_outline,
                                label: '${_fmt(lounge.members)} members'),
                            const SizedBox(width: 12),
                            _StatChip(
                                icon: Icons.article_outlined,
                                label: '${_fmt(lounge.posts)} posts/week'),
                            if (lounge.university != null) ...[
                              const SizedBox(width: 12),
                              _StatChip(
                                  icon: Icons.location_on_outlined,
                                  label: lounge.university!),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: context.border, width: 0.5)),
                ),
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
          children: _tabs
              .map((_) => _ChannelPostFeed(posts: _posts, lounge: lounge))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen())),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.edit_outlined, color: Colors.white),
      ),
    );
  }

  void _showChannelOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        decoration: BoxDecoration(
            color: context.bgCard, borderRadius: BorderRadius.circular(20)),
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
            _SheetTile(
                icon: Icons.notifications_outlined,
                label: 'Mute channel',
                onTap: () => Navigator.pop(context)),
            _SheetTile(
                icon: Icons.bookmark_border,
                label: 'Save channel',
                onTap: () => Navigator.pop(context)),
            _SheetTile(
                icon: Icons.share_outlined,
                label: 'Share channel',
                onTap: () => Navigator.pop(context)),
            _SheetTile(
                icon: Icons.flag_outlined,
                label: 'Report channel',
                color: AppTheme.red,
                onTap: () => Navigator.pop(context)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Post feed ─────────────────────────────────────────────────────────────────
class _ChannelPostFeed extends StatelessWidget {
  final List<Post> posts;
  final Lounge lounge;
  const _ChannelPostFeed({required this.posts, required this.lounge});

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
                style: TextStyle(fontSize: 13, color: context.txtLight)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: posts.length,
      itemBuilder: (ctx, i) {
        final p = posts[i];
        // ✅ FIXED: new PostCard API
        return PostCard(
          post: p,
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => PostDetailScreen(post: p)),
          ),
        );
      },
    );
  }
}

// ── Stat chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: context.txtLight),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: context.txtSub)),
      ],
    );
  }
}

// ── Sheet tile ────────────────────────────────────────────────────────────────
class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _SheetTile(
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
                    fontSize: 14, fontWeight: FontWeight.w500, color: c)),
          ],
        ),
      ),
    );
  }
}