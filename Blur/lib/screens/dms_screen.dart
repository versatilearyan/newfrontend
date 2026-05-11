import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'chat_screen.dart';

class DmsScreen extends StatefulWidget {
  const DmsScreen({super.key});

  @override
  State<DmsScreen> createState() => _DmsScreenState();
}

class _DmsScreenState extends State<DmsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Message> _filtered = sampleMessages;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _isSearching = q.isNotEmpty;
      _filtered = q.isEmpty
          ? sampleMessages
          : sampleMessages.where((m) {
              return m.sender.toLowerCase().contains(q) ||
                  m.preview.toLowerCase().contains(q) ||
                  (m.university?.toLowerCase().contains(q) ?? false);
            }).toList();
    });
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MoreMenuSheet(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPage,
      appBar: AppBar(
        backgroundColor: context.bgSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Blur',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: context.txtMain,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: context.txtMain),
            onPressed: _showMoreMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // Encryption banner
          Container(
            color: context.bgSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 13, color: context.txtLight),
                const SizedBox(width: 6),
                Text(
                  'End-to-End Encrypted',
                  style: TextStyle(fontSize: 12, color: context.txtLight),
                ),
              ],
            ),
          ),
          Container(height: 0.5, color: context.border),

          // ── Live Search Bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: context.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.border, width: 0.8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: context.txtLight, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: TextStyle(fontSize: 14, color: context.txtMain),
                      decoration: InputDecoration(
                        hintText: 'Search conversations',
                        hintStyle:
                            TextStyle(fontSize: 13, color: context.txtLight),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_isSearching)
                    GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(Icons.close,
                            size: 18, color: context.txtLight),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Results count label
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Row(
                children: [
                  Text(
                    '${_filtered.length} result${_filtered.length == 1 ? '' : 's'} for "${_searchCtrl.text.trim()}"',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.txtLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // ── Messages List / Empty State ─────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState(isSearching: _isSearching)
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 100),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final msg = _filtered[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              userName: msg.sender,
                              userInitials: msg.sender
                                  .split(' ')
                                  .map((e) => e[0])
                                  .join()
                                  .toUpperCase(),
                            ),
                          ),
                        ),
                        child: _MessageTile(message: msg),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isSearching;
  const _EmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching
                ? Icons.search_off_rounded
                : Icons.chat_bubble_outline,
            size: 52,
            color: context.txtLight,
          ),
          const SizedBox(height: 14),
          Text(
            isSearching ? 'No conversations found' : 'No messages yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.txtSub,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isSearching
                ? 'Try a different search term'
                : 'Start a conversation on a post',
            style: TextStyle(fontSize: 13, color: context.txtLight),
          ),
        ],
      ),
    );
  }
}

// ── Message Tile ──────────────────────────────────────────────────────────────
class _MessageTile extends StatelessWidget {
  final Message message;
  const _MessageTile({required this.message});

  static const _colors = [
    Color(0xFF3B5BDB),
    Color(0xFF7C3AED),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFFDC2626),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = message.id.hashCode % _colors.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: message.isUnread
              ? AppTheme.primary.withOpacity(0.35)
              : context.border,
          width: message.isUnread ? 1.2 : 0.5,
        ),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnonAvatar(
                size: 46,
                initials: 'A',
                bg: _colors[idx.abs()],
              ),
              if (message.university != null)
                Positioned(
                  bottom: -2,
                  right: -4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: context.bgCard, width: 1.5),
                    ),
                    child: Text(
                      message.university!,
                      style: const TextStyle(
                        fontSize: 7,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Anonymous User',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.txtMain,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      message.timeAgo,
                      style: TextStyle(fontSize: 11, color: context.txtLight),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: message.isUnread
                              ? context.txtMain
                              : context.txtSub,
                          fontWeight: message.isUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (message.isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── ⋯ More Menu Bottom Sheet ──────────────────────────────────────────────────
class _MoreMenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              decoration: BoxDecoration(
                color: context.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'More Options',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.txtMain,
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: context.border),

            // Report a Problem
            _MenuRow(
              icon: Icons.flag_outlined,
              iconBg: const Color(0xFFFFEDD5),
              iconColor: const Color(0xFFEA580C),
              title: 'Report a Problem',
              subtitle: 'Something not working right?',
              onTap: () {
                Navigator.pop(context);
                _showReportProblemSheet(context);
              },
            ),
            Divider(height: 1, color: context.border, indent: 72),

            // Help
            _MenuRow(
              icon: Icons.help_outline_rounded,
              iconBg: const Color(0xFFE0E7FF),
              iconColor: AppTheme.primary,
              title: 'Help',
              subtitle: 'FAQs and contact support',
              onTap: () {
                Navigator.pop(context);
                _showHelpSheet(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// ── Report a Problem Sheet ────────────────────────────────────────────────────
void _showReportProblemSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReportProblemSheet(),
  );
}

class _ReportProblemSheet extends StatefulWidget {
  @override
  State<_ReportProblemSheet> createState() => _ReportProblemSheetState();
}

class _ReportProblemSheetState extends State<_ReportProblemSheet> {
  final _ctrl = TextEditingController();
  int _selectedCat = 0;
  final _cats = ['Bug', 'Crash', 'DM Issue', 'Account', 'Other'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: context.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title row
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.flag_outlined,
                          color: Color(0xFFEA580C), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Report a Problem',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: context.txtMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Category
                Text(
                  'CATEGORY',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: context.txtLight,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_cats.length, (i) {
                    final sel = i == _selectedCat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCat = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppTheme.primary
                              : AppTheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: sel
                                ? AppTheme.primary
                                : AppTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          _cats[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : AppTheme.primary,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: context.txtLight,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: context.bgPage,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.border, width: 0.8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: TextField(
                    controller: _ctrl,
                    maxLines: 4,
                    style:
                        TextStyle(fontSize: 14, color: context.txtMain),
                    decoration: InputDecoration(
                      hintText:
                          'Describe the issue you\'re experiencing...',
                      hintStyle: TextStyle(
                          fontSize: 13, color: context.txtLight),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              '✅ Problem reported. We\'ll look into it!'),
                          backgroundColor: Color(0xFF059669),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA580C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Submit Report',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Help Sheet ────────────────────────────────────────────────────────────────
void _showHelpSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.72,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (ctx, scroll) => Container(
        decoration: BoxDecoration(
          color: ctx.bgCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              decoration: BoxDecoration(
                color: ctx.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.help_outline_rounded,
                        color: AppTheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Help Center',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: ctx.txtMain,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: ctx.border),

            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                children: [
                  _sectionLabel('MESSAGING', ctx),
                  _FaqItem(
                    q: 'Why can\'t I send pictures?',
                    a: 'CampusBlind is designed for anonymous text-based conversations. Pictures are disabled to protect user privacy and maintain anonymity.',
                  ),
                  _FaqItem(
                    q: 'Why was my message blocked?',
                    a: 'Messages containing only numbers are not allowed. Please include text in your message. This helps prevent spam.',
                  ),
                  _FaqItem(
                    q: 'How many DMs can I send per day?',
                    a: 'Free accounts can send up to 5 DMs per day. Upgrade to Premium for unlimited messages.',
                  ),
                  const SizedBox(height: 16),
                  _sectionLabel('ACCOUNT & PRIVACY', ctx),
                  _FaqItem(
                    q: 'How is my identity protected?',
                    a: 'All messages are end-to-end encrypted. Your real identity is never shared. You always appear as "Anonymous User".',
                  ),
                  _FaqItem(
                    q: 'How do I block someone?',
                    a: 'Open a chat, tap the ⋯ menu at the top right, then select "Block User". They will no longer be able to message you.',
                  ),
                  _FaqItem(
                    q: 'How do I report a user?',
                    a: 'Open the chat, tap ⋯, then "Report User". Our moderation team reviews all reports within 24 hours.',
                  ),
                  const SizedBox(height: 16),
                  _sectionLabel('GENERAL', ctx),
                  _FaqItem(
                    q: 'What universities are supported?',
                    a: 'Any university with a valid .edu email is supported. Verify your email during onboarding.',
                  ),
                  _FaqItem(
                    q: 'How do I delete my account?',
                    a: 'Go to Settings → Account → Delete Account. This is permanent and all your data will be erased.',
                  ),
                  const SizedBox(height: 20),

                  // Contact Support card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.primary.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.support_agent,
                            color: AppTheme.primary, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          'Still need help?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: ctx.txtMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Our team typically responds within 24 hours',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, color: ctx.txtSub),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      '📧 support@campusblind.com'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Contact Support',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _sectionLabel(String label, BuildContext ctx) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: ctx.txtLight,
        ),
      ),
    );

// ── Expandable FAQ Item ───────────────────────────────────────────────────────
class _FaqItem extends StatefulWidget {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.bgPage,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.q,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: context.txtMain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: context.txtLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 13),
              child: Text(
                widget.a,
                style: TextStyle(
                  fontSize: 13,
                  color: context.txtSub,
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState:
                _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// ── More Menu Row ─────────────────────────────────────────────────────────────
class _MenuRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.txtMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: context.txtSub),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.txtLight, size: 18),
          ],
        ),
      ),
    );
  }
}