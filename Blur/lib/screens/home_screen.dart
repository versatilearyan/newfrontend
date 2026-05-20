import 'package:campusblind/screens/lounges_screen.dart' show LoungesScreen;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../models/channel_model.dart';
import '../widgets/shared_widgets.dart';
import 'dms_screen.dart';
import 'profile_screen.dart';
import 'create_post_screen.dart';
import 'create_channel_screen.dart';
import 'post_detail_screen.dart';
import 'lounge_feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late TabController _tabCtrl;
  final _tabs = ['All', 'My Campus', 'Trending', 'Academics', 'For You'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static bool _hasLoadedOnce = false;
  bool _isLoading = false;
  bool hasNotification = true;

  final List<ChannelModel> _myChannels = [
    ChannelModel(emoji: '🏫', name: 'My Campus',     subtitle: 'Private · My Campus'),
    ChannelModel(emoji: '🔵', name: 'Blur Official', subtitle: 'Public'),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
    if (!_hasLoadedOnce) {
      _isLoading = true;
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) {
          setState(() => _isLoading = false);
          _hasLoadedOnce = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _onChannelCreated(ChannelModel ch) {
    if (mounted) setState(() => _myChannels.add(ch));
  }

  void _onNavTap(int i) {
    if (i == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const CreatePostScreen()));
      return;
    }
    setState(() => _navIndex = i);
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _SkeletonFeedTab(
          tabCtrl: _tabCtrl, tabs: _tabs, scaffoldKey: _scaffoldKey);
    }
    switch (_navIndex) {
      case 0:
        return _FeedTab(
          tabCtrl: _tabCtrl,
          tabs: _tabs,
          scaffoldKey: _scaffoldKey,
          onNotificationDismiss: () => setState(() => hasNotification = false),
        );
      case 1:
        return const LoungesScreen();
      case 3:
        return const DmsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _FeedTab(
          tabCtrl: _tabCtrl,
          tabs: _tabs,
          scaffoldKey: _scaffoldKey,
          onNotificationDismiss: () => setState(() => hasNotification = false),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.bgPage,
      drawer: _CampusDrawer(
        myChannels: _myChannels,
        onChannelCreated: _onChannelCreated,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _buildBody(),
      ),
      bottomNavigationBar: CampusBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ── Campus Drawer ─────────────────────────────────────────────────────────────
class _CampusDrawer extends StatefulWidget {
  final List<ChannelModel> myChannels;
  final void Function(ChannelModel) onChannelCreated;

  const _CampusDrawer({
    required this.myChannels,
    required this.onChannelCreated,
  });

  @override
  State<_CampusDrawer> createState() => _CampusDrawerState();
}

class _CampusDrawerState extends State<_CampusDrawer> {
  // ✅ Favorites = top 7 lounges by members from sampleLounges
  late final List<ChannelModel> _favorites = () {
    final sorted = [...sampleLounges]
      ..sort((a, b) => b.members.compareTo(a.members));
    return sorted.take(7).map((l) => ChannelModel(
      emoji: '',
      name: l.name,
      subtitle: l.category,
      isFav: true,
    )).toList();
  }();

  // ✅ Channels I Follow = remaining lounges from sampleLounges
  late final List<ChannelModel> _following = () {
    final sorted = [...sampleLounges]
      ..sort((a, b) => b.members.compareTo(a.members));
    return sorted.skip(7).map((l) => ChannelModel(
      emoji: '',
      name: l.name,
      subtitle: l.category,
      isFav: false,
    )).toList();
  }();

  void _openChannel(BuildContext ctx, ChannelModel ch) {
    // ✅ Try to find the real Lounge from sampleLounges first (has members/posts data)
    final realLounge = sampleLounges.cast<Lounge?>().firstWhere(
      (l) => l!.name == ch.name,
      orElse: () => null,
    );

    final lounge = realLounge ?? Lounge(
      id: ch.name.toLowerCase().replaceAll(' ', '_'),
      name: ch.name,
      category: _inferCategory(ch.subtitle),
      members: 0,
      posts: 0,
    );

    Navigator.pop(ctx);
    Future.delayed(const Duration(milliseconds: 280), () {
      if (ctx.mounted) {
        Navigator.push(ctx,
            MaterialPageRoute(builder: (_) => LoungeFeedScreen(lounge: lounge)));
      }
    });
  }

  String _inferCategory(String subtitle) {
    final s = subtitle.toLowerCase();
    if (s.contains('sports'))   return 'Sports';
    if (s.contains('academic')) return 'Academics';
    if (s.contains('private'))  return 'Private';
    if (s.contains('social'))   return 'Social';
    if (s.contains('career'))   return 'Career';
    if (s.contains('housing'))  return 'Housing';
    return 'General';
  }

  void _toggleMyChannelFav(int index) {
    if (!mounted) return;
    setState(() {
      final item = widget.myChannels[index];
      item.isFav = !item.isFav;
      if (item.isFav) {
        _favorites.insert(0, ChannelModel(
          emoji: item.emoji, name: item.name,
          subtitle: item.subtitle, badge: item.badge, isFav: true,
        ));
      } else {
        _favorites.removeWhere((f) => f.name == item.name);
      }
    });
  }

  void _toggleFav(int index) {
    if (!mounted) return;
    setState(() {
      final removed = _favorites.removeAt(index);
      final mi = widget.myChannels.indexWhere((c) => c.name == removed.name);
      if (mi != -1) widget.myChannels[mi].isFav = false;
    });
  }

  void _toggleFollowingFav(int index) {
    if (!mounted) return;
    setState(() {
      final item = _following[index];
      item.isFav = !item.isFav;
      if (item.isFav) {
        _favorites.add(ChannelModel(
          emoji: item.emoji, name: item.name,
          subtitle: item.subtitle, badge: item.badge, isFav: true,
        ));
      } else {
        _favorites.removeWhere((f) => f.name == item.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.bgPage,
      width: MediaQuery.of(context).size.width * 0.82,
      child: Column(
        children: [
          Container(
            color: context.bgSurface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20, right: 20, bottom: 20,
            ),
            child: Row(
              children: [
                // ✅ Real Blur logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/blur_logo.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('blur',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Blur',
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.w800, color: context.txtMain)),
                    const SizedBox(height: 2),
                    Text('Your Anonymous Campus',
                        style: TextStyle(fontSize: 12, color: context.txtSub)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerSectionHeader(
                  title: 'My Channels',
                  action: '+ Create',
                  onAction: () {
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 250), () {
                      if (!context.mounted) return;
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CreateChannelScreen(
                          onChannelCreated: (ch) {
                            widget.onChannelCreated(ch);
                            if (mounted) setState(() {});
                          },
                        ),
                      ));
                    });
                  },
                ),
                ...widget.myChannels.asMap().entries.map((e) => _DrawerChannelTile(
                      item: e.value,
                      onTap: () => _openChannel(context, e.value),
                      onStarTap: () => _toggleMyChannelFav(e.key),
                    )),
                Divider(color: context.border, height: 1, thickness: 1),
                const SizedBox(height: 4),
                _DrawerSectionHeader(
                  title: 'Favorites',
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF59E0B),
                ),
                if (_favorites.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text('No favorites yet — tap ☆ to add',
                        style: TextStyle(fontSize: 12, color: context.txtLight)),
                  )
                else
                  ..._favorites.asMap().entries.map((e) => _DrawerChannelTile(
                        item: e.value,
                        onTap: () => _openChannel(context, e.value),
                        onStarTap: () => _toggleFav(e.key),
                      )),
                Divider(color: context.border, height: 1, thickness: 1),
                const SizedBox(height: 4),
                const _DrawerSectionHeader(title: 'Channels I Follow'),
                ..._following.asMap().entries.map((e) => _DrawerChannelTile(
                      item: e.value,
                      onTap: () => _openChannel(context, e.value),
                      onStarTap: () => _toggleFollowingFav(e.key),
                    )),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _DrawerSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final IconData? icon;
  final Color? iconColor;

  const _DrawerSectionHeader({
    required this.title,
    this.action,
    this.onAction,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.bgSurface,
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
          ],
          Text(title,
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700, color: context.txtMain)),
          const Spacer(),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!,
                  style: const TextStyle(fontSize: 13,
                      color: AppTheme.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

// ── Channel tile ──────────────────────────────────────────────────────────────
class _DrawerChannelTile extends StatelessWidget {
  final ChannelModel item;
  final VoidCallback onTap;
  final VoidCallback onStarTap;

  const _DrawerChannelTile({
    required this.item,
    required this.onTap,
    required this.onStarTap,
  });

  // Same icon/color map as LoungeStyle in lounges_screen.dart
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

  @override
  Widget build(BuildContext context) {
    // Blur Official → show logo image
    // Other channels from sampleLounges → show category icon
    // Legacy emoji channels → show emoji
    final lounge = sampleLounges.cast<Lounge?>()
        .firstWhere((l) => l!.name == item.name, orElse: () => null);
    final cat = lounge?.category ?? item.subtitle;
    final color = _colors[cat] ?? AppTheme.primary;
    final icon  = _icons[cat] ?? Icons.tag;

    return Material(
      color: context.bgPage,
      child: InkWell(
        onTap: onTap,
        splashColor: AppTheme.primary.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              // ── Avatar ───────────────────────────────────────────────
              if (item.name == 'Blur Official')
                // Real logo for Blur Official
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/blur_logo.png',
                    width: 46, height: 46, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('blur',
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w800, fontSize: 12)),
                      ),
                    ),
                  ),
                )
              else if (item.emoji.isEmpty)
                // ✅ Lounge from sampleLounges → profile photo
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: lounge?.profileImageUrl != null
                        ? Image.network(
                            lounge!.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(icon, color: color, size: 22),
                            loadingBuilder: (_, child, prog) =>
                                prog == null
                                    ? child
                                    : Icon(icon, color: color, size: 22),
                          )
                        : Icon(icon, color: color, size: 22),
                  ),
                )
              else
                // Legacy / manually created channel → emoji
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: context.bgCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(item.emoji,
                        style: const TextStyle(fontSize: 22))),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.txtMain)),
                    const SizedBox(height: 2),
                    Text(item.subtitle,
                        style: TextStyle(fontSize: 12, color: context.txtSub)),
                  ],
                ),
              ),
              if (item.badge > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item.badge > 99 ? '99+' : '${item.badge}',
                      style: const TextStyle(fontSize: 11,
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
              ],
              GestureDetector(
                onTap: onStarTap,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      item.isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                      key: ValueKey(item.isFav),
                      color: item.isFav
                          ? const Color(0xFFF59E0B)
                          : context.txtLight,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const _Shimmer({required this.width, required this.height, this.radius = 8});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
    _anim = Tween<double>(begin: -2, end: 2)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8EAF0);
    final hi   = context.isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF4F5F9);
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            colors: [base, hi, base],
            stops: [
              (_anim.value - 0.5).clamp(0.0, 1.0),
              _anim.value.clamp(0.0, 1.0),
              (_anim.value + 0.5).clamp(0.0, 1.0),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Skeleton post card ────────────────────────────────────────────────────────
class _SkeletonPostCard extends StatelessWidget {
  const _SkeletonPostCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _Shimmer(width: 40, height: 40, radius: 20),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Shimmer(width: 100, height: 12, radius: 6),
              const SizedBox(height: 5),
              _Shimmer(width: 70, height: 10, radius: 5),
            ]),
            const Spacer(),
            _Shimmer(width: 40, height: 14, radius: 6),
          ]),
          const SizedBox(height: 12),
          _Shimmer(width: 200, height: 16, radius: 6),
          const SizedBox(height: 8),
          _Shimmer(width: double.infinity, height: 13, radius: 6),
          const SizedBox(height: 6),
          _Shimmer(width: double.infinity, height: 13, radius: 6),
          const SizedBox(height: 6),
          _Shimmer(width: 160, height: 13, radius: 6),
          const SizedBox(height: 14),
          Row(children: [
            _Shimmer(width: 48, height: 14, radius: 6),
            const SizedBox(width: 16),
            _Shimmer(width: 48, height: 14, radius: 6),
            const SizedBox(width: 16),
            _Shimmer(width: 48, height: 14, radius: 6),
            const Spacer(),
            _Shimmer(width: 20, height: 14, radius: 6),
          ]),
        ],
      ),
    );
  }
}

// ── Skeleton feed tab ─────────────────────────────────────────────────────────
class _SkeletonFeedTab extends StatelessWidget {
  final TabController tabCtrl;
  final List<String> tabs;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _SkeletonFeedTab(
      {required this.tabCtrl, required this.tabs, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      key: const ValueKey('skeleton'),
      headerSliverBuilder: (_, __) => [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: context.bgSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () => scaffoldKey.currentState?.openDrawer(),
                child: Icon(Icons.menu, color: context.txtMain, size: 24),
              ),
              const SizedBox(width: 12),
              Text('Blur',
                  style: TextStyle(fontSize: 17,
                      fontWeight: FontWeight.w700, color: context.txtMain)),
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.search, color: context.txtMain),
                onPressed: null),
          ],
          bottom: TabBar(
            controller: tabCtrl,
            isScrollable: true,
            labelColor: AppTheme.primary,
            unselectedLabelColor: context.txtSub,
            indicatorColor: AppTheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabAlignment: TabAlignment.start,
            tabs: tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
      ],
      body: TabBarView(
        controller: tabCtrl,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          tabs.length,
          (_) => ListView(
            padding: const EdgeInsets.only(top: 10, bottom: 80),
            children: [
              for (int i = 0; i < 4; i++) const _SkeletonPostCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Real Feed Tab ─────────────────────────────────────────────────────────────
class _FeedTab extends StatefulWidget {
  final TabController tabCtrl;
  final List<String> tabs;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onNotificationDismiss;

  const _FeedTab({
    required this.tabCtrl,
    required this.tabs,
    required this.scaffoldKey,
    required this.onNotificationDismiss,
  });

  @override
  State<_FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<_FeedTab> {
  bool _searchOpen = false;
  String _query = '';
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  List<Post> get _allPosts => [...samplePosts, ...trendingPosts];

  List<Post> get _results {
    if (_query.isEmpty) return _allPosts;
    final q = _query.toLowerCase();
    return _allPosts.where((p) =>
        (p.title?.toLowerCase().contains(q) ?? false) ||
        p.content.toLowerCase().contains(q) ||
        (p.lounge?.toLowerCase().contains(q) ?? false) ||
        (p.university?.toLowerCase().contains(q) ?? false) ||
        p.username.toLowerCase().contains(q)).toList();
  }

  void _openSearch() {
    setState(() => _searchOpen = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocus.requestFocus();
    });
  }

  void _closeSearch() {
    _searchCtrl.clear();
    _searchFocus.unfocus();
    setState(() {
      _searchOpen = false;
      _query = '';
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      key: const ValueKey('feed'),
      headerSliverBuilder: (_, __) => [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: context.bgSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _searchOpen
                // ── Search input ─────────────────────────────────────
                ? Row(
                    key: const ValueKey('search'),
                    children: [
                      Expanded(
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: context.bgCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.border),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Icon(Icons.search,
                                  color: context.txtLight, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchCtrl,
                                  focusNode: _searchFocus,
                                  style: TextStyle(
                                      fontSize: 14, color: context.txtMain),
                                  decoration: InputDecoration(
                                    hintText: 'Search posts, lounges...',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: context.txtLight),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (v) =>
                                      setState(() => _query = v),
                                ),
                              ),
                              if (_query.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _searchCtrl.clear();
                                    setState(() => _query = '');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(Icons.close,
                                        size: 15, color: context.txtLight),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _closeSearch,
                        child: Text('Cancel',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  )
                // ── Normal title ─────────────────────────────────────
                : Row(
                    key: const ValueKey('title'),
                    children: [
                      GestureDetector(
                        onTap: () =>
                            widget.scaffoldKey.currentState?.openDrawer(),
                        child: Icon(Icons.menu,
                            color: context.txtMain, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text('Blur',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: context.txtMain)),
                    ],
                  ),
          ),
          actions: _searchOpen
              ? [] // hide when search is open
              : [
                  IconButton(
                    icon: Icon(Icons.search, color: context.txtMain),
                    onPressed: _openSearch, // ✅ functional
                  ),
                ],
          bottom: _searchOpen
              ? null // hide tabs during search
              : PreferredSize(
                  preferredSize: const Size.fromHeight(44),
                  child: TabBar(
                    controller: widget.tabCtrl,
                    isScrollable: true,
                    labelColor: AppTheme.primary,
                    unselectedLabelColor: context.txtSub,
                    indicatorColor: AppTheme.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    tabAlignment: TabAlignment.start,
                    tabs: widget.tabs.map((t) => Tab(text: t)).toList(),
                  ),
                ),
        ),
      ],
      body: _searchOpen
          // ── Search results ──────────────────────────────────────────
          ? _SearchResults(query: _query, results: _results)
          // ── Normal feed ─────────────────────────────────────────────
          : TabBarView(
              controller: widget.tabCtrl,
              children: [
                _AllFeed(),
                _AllFeed(),
                _TrendingFeed(),
                _AcademicsFeed(),
                _ForYouFeed(),
              ],
            ),
    );
  }
}

// ── Search results feed ────────────────────────────────────────────────────────
class _SearchResults extends StatelessWidget {
  final String query;
  final List<Post> results;
  const _SearchResults({required this.query, required this.results});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      // Show recent / suggestions when bar is open but empty
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          Text('Try searching for...',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.txtSub)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              'Placements', 'Confessions', 'Hostel Life',
              'Crush Corner', 'Memes', 'Midnight Thoughts',
              'College Drama', 'Internship',
            ].map((tag) => GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('#$tag',
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600)),
              ),
            )).toList(),
          ),
        ],
      );
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: context.txtLight),
            const SizedBox(height: 12),
            Text('No results for "$query"',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.txtSub)),
            const SizedBox(height: 6),
            Text('Try different keywords',
                style: TextStyle(fontSize: 13, color: context.txtLight)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'} for "$query"',
            style: TextStyle(fontSize: 13, color: context.txtSub),
          ),
        ),
        ...results.map((p) => PostCard(
              post: p,
              onTap: () => _goToPost(context, p),
            )),
      ],
    );
  }
}

// ── Helper: navigate to post detail ──────────────────────────────────────────
void _goToPost(BuildContext context, Post p) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => PostDetailScreen(post: p)),
  );
}

// ── All Feed ──────────────────────────────────────────────────────────────────
class _AllFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        // ✅ NEW: PostCard(post: p, onTap: ...)
        ...samplePosts.map((p) => PostCard(
              post: p,
              onTap: () => _goToPost(context, p),
            )),
        // Join campus banner
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B5BDB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Join your campus',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 6),
              const Text(
                "Verify your .edu email to unlock exclusive access to your university's private lounge.",
                style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Get Verified',
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700, color: AppTheme.primary)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Trending Feed ─────────────────────────────────────────────────────────────
class _TrendingFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trending Now',
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700, color: context.txtMain)),
              const Text('Sort by: Trending',
                  style: TextStyle(fontSize: 12,
                      color: AppTheme.primary, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        // ✅ NEW API
        ...trendingPosts.map((p) => PostCard(
              post: p,
              onTap: () => _goToPost(context, p),
            )),
      ],
    );
  }
}

// ── Academics Feed ────────────────────────────────────────────────────────────
class _AcademicsFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final posts = samplePosts
        .where((p) => p.lounge == 'Academics' || p.lounge == 'Confessions')
        .toList();
    final all = posts.isEmpty ? samplePosts : posts;
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: all.map((p) => PostCard(
            post: p,
            onTap: () => _goToPost(context, p),
          )).toList(),
    );
  }
}

// ── For You Feed ──────────────────────────────────────────────────────────────
class _ForYouFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final posts = [
      ...samplePosts.take(2),
      ...trendingPosts,
      ...samplePosts.skip(2),
    ];
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text('Recommended for you',
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700, color: context.txtMain)),
            ],
          ),
        ),
        // ✅ NEW API
        ...posts.map((p) => PostCard(
              post: p,
              onTap: () => _goToPost(context, p),
            )),
      ],
    );
  }
}