import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _privateProfile = false;

  @override
  Widget build(BuildContext context) {
    final appState = BlurApp.of(context);
    final darkOn = appState?.isDark ?? false;

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
        title: Text('Settings',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: context.txtMain)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 40),
        children: [
          // Free DMs banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('5 free DMs remaining',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary)),
                      Text('Resets in 24 hours',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.primary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Upgrade',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _SectionLabel(label: 'APPEARANCE'),
          _SettingsGroup(children: [
            _SettingTile(
              icon: Icons.dark_mode_outlined,
              label: 'Dark Mode',
              trailing: Switch(
                value: darkOn,
                onChanged: (v) {
                  appState?.toggleTheme(v);
                  setState(() {}); // rebuild to reflect new theme
                },
                activeColor: AppTheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _SectionLabel(label: 'NOTIFICATIONS'),
          _SettingsGroup(children: [
            _SettingTile(
              icon: Icons.notifications_outlined,
              label: 'Push Notifications',
              trailing: Switch(
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
                activeColor: AppTheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            _SettingTile(
              icon: Icons.mark_chat_unread_outlined,
              label: 'DM Notifications',
              trailing:
                  Icon(Icons.chevron_right, color: context.txtLight),
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),

          _SectionLabel(label: 'PRIVACY & SAFETY'),
          _SettingsGroup(children: [
            _SettingTile(
              icon: Icons.security_outlined,
              label: 'Privacy & Safety',
              trailing:
                  Icon(Icons.chevron_right, color: context.txtLight),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.person_outline,
              label: 'Private Profile',
              trailing: Switch(
                value: _privateProfile,
                onChanged: (v) =>
                    setState(() => _privateProfile = v),
                activeColor: AppTheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _SectionLabel(label: 'MESSAGING'),
          _SettingsGroup(children: [
            _SettingTile(
              icon: Icons.chat_outlined,
              label: 'DM & Messaging',
              subtitle: '5 free DMs / day',
              trailing:
                  Icon(Icons.chevron_right, color: context.txtLight),
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),

          _SectionLabel(label: 'ACCOUNT'),
          _SettingsGroup(children: [
            _SettingTile(
              icon: Icons.help_outline,
              label: 'Help & Support',
              trailing:
                  Icon(Icons.chevron_right, color: context.txtLight),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.info_outline,
              label: 'About CampusBlind',
              trailing:
                  Icon(Icons.chevron_right, color: context.txtLight),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.logout,
              label: 'Log Out',
              iconColor: Colors.red,
              labelColor: Colors.red,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/onboarding', (_) => false),
            ),
          ]),
          const SizedBox(height: 24),

          Center(
            child: Text('CampusBlind v1.0.0',
                style: TextStyle(
                    fontSize: 12, color: context.txtLight)),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: context.txtLight)),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingTile> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.border, width: 0.5),
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          final isLast = e.key == children.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast)
                Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: context.border,
                    indent: 52),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _SettingTile({
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
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 13),
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