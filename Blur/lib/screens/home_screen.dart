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
  final List<ChannelModel> _favorites = [
    ChannelModel(emoji: '🏏', name: 'Cricket',            subtitle: 'Public · Sports', badge: 4,  isFav: true),
    ChannelModel(emoji: '💕', name: 'India Relationships', subtitle: 'Public',          badge: 1,  isFav: true),
    ChannelModel(emoji: '🏛️', name: 'Indian Politics',     subtitle: 'Public',                     isFav: true),
    ChannelModel(emoji: '📰', name: 'India News',          subtitle: 'Public',                     isFav: true),
    ChannelModel(emoji: '💼', name: 'India WorkLife',      subtitle: 'Public',          badge: 99, isFav: true),
    ChannelModel(emoji: '🇮🇳', name: 'India',              subtitle: 'Public',                     isFav: true),
    ChannelModel(emoji: '🌐', name: 'Namma Bangalore',     subtitle: 'Public',                     isFav: true),
  ];

  final List<ChannelModel> _following = [
    ChannelModel(emoji: '😂', name: 'LinkedIn Cringe',  subtitle: 'Public',            isFav: false),
    ChannelModel(emoji: '📚', name: 'Study Groups',     subtitle: 'Public',            isFav: false),
    ChannelModel(emoji: '💻', name: 'Internship Board', subtitle: 'Public', badge: 12, isFav: false),
  ];

  void _openChannel(BuildContext ctx, ChannelModel ch) {
    final lounge = Lounge(
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.bgPage,
      child: InkWell(
        onTap: onTap,
        splashColor: AppTheme.primary.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
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
class _FeedTab extends StatelessWidget {
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
                onPressed: () {}),
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