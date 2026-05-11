import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import '../main.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.bgPage,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: context.bgSurface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                // ✅ Real Blur logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    'assets/images/blur_logo.png',
                    width: 28, height: 28, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Center(
                        child: Text('b',
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('blur',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: context.txtMain)),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.menu, color: context.txtMain),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
          ),

          // Profile header
          SliverToBoxAdapter(
            child: Container(
              color: context.bgSurface,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                children: [
                  // Avatar + edit
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const AnonAvatar(
                          size: 76,
                          initials: 'JD',
                          bg: AppTheme.primary),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: context.bgSurface, width: 2),
                        ),
                        child: const Icon(Icons.edit,
                            size: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Name + verified
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Anonymous Student',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: context.txtMain)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('VERIFIED',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text('📍 Stanford University',
                      style: TextStyle(
                          fontSize: 13, color: context.txtSub)),
                  const SizedBox(height: 2),
                  Text('Joined Sept 2023',
                      style: TextStyle(
                          fontSize: 12, color: context.txtLight)),
                  const SizedBox(height: 14),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatItem(
                          label: 'Posts',
                          value: '24',
                          context: context),
                      _StatDivider(),
                      _StatItem(
                          label: 'Likes',
                          value: '312',
                          context: context),
                      _StatDivider(),
                      _StatItem(
                          label: 'Comments',
                          value: '87',
                          context: context),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Edit profile button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('Edit Profile',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.txtMain)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tab bar
                  TabBar(
                    controller: _tabCtrl,
                    labelColor: AppTheme.primary,
                    unselectedLabelColor: context.txtSub,
                    indicatorColor: AppTheme.primary,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    tabs: const [
                      Tab(text: 'My Posts'),
                      Tab(text: 'My Comments'),
                      Tab(text: 'Bookmarks'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Settings section header
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Settings',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.txtMain)),
                ),
                const SizedBox(height: 10),
                _InlineSettings(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Activity',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.txtMain)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: samplePosts
                  .map((p) => PostCard(post: p))
                  .toList(),
            ),
            Center(
                child: Text('No comments yet',
                    style: TextStyle(color: context.txtSub))),
            Center(
                child: Text('No bookmarks yet',
                    style: TextStyle(color: context.txtSub))),
          ],
        ),
      ),
    );
  }
}

// ── Inline Settings panel inside Profile ─────────────────────────────────────
class _InlineSettings extends StatefulWidget {
  @override
  State<_InlineSettings> createState() => _InlineSettingsState();
}

class _InlineSettingsState extends State<_InlineSettings> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final appState = BlurApp.of(context);
    final darkOn = appState?.isDark ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Dark Mode
          _SettingRow(
            icon: Icons.dark_mode_outlined,
            label: 'Dark Mode',
            trailing: Switch(
              value: darkOn,
              onChanged: (v) => appState?.toggleTheme(v),
              activeColor: AppTheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Divider(height: 0.5, thickness: 0.5,
              color: context.border, indent: 52),

          // Notifications
          _SettingRow(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            trailing: Switch(
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
              activeColor: AppTheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Divider(height: 0.5, thickness: 0.5,
              color: context.border, indent: 52),

          // Privacy & Safety
          _SettingRow(
            icon: Icons.security_outlined,
            label: 'Privacy & Safety',
            trailing: Icon(Icons.chevron_right, color: context.txtLight),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          Divider(height: 0.5, thickness: 0.5,
              color: context.border, indent: 52),

          // DM & Messaging
          _SettingRow(
            icon: Icons.chat_outlined,
            label: 'DM & Messaging',
            subtitle: '5 free DMs / day',
            trailing: Icon(Icons.chevron_right, color: context.txtLight),
            onTap: () {},
          ),
          Divider(height: 0.5, thickness: 0.5,
              color: context.border, indent: 52),

          // Log Out
          _SettingRow(
            icon: Icons.logout,
            label: 'Log Out',
            iconColor: Colors.red,
            labelColor: Colors.red,
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/onboarding', (_) => false),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _SettingRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: iconColor ?? context.txtSub),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: labelColor ?? context.txtMain)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: TextStyle(
                            fontSize: 11.5,
                            color: context.txtLight)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;
  const _StatItem(
      {required this.label,
      required this.value,
      required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: context.txtMain)),
          Text(label,
              style: TextStyle(
                  fontSize: 11.5, color: context.txtSub)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 28, width: 0.5, color: context.border);
  }
}