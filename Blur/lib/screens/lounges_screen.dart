import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'lounge_feed_screen.dart'; // ✅ navigation target

class LoungesScreen extends StatefulWidget {
  const LoungesScreen({super.key});

  @override
  State<LoungesScreen> createState() => _LoungesScreenState();
}

class _LoungesScreenState extends State<LoungesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  List<Lounge> get _filtered => _query.isEmpty
      ? sampleLounges
      : sampleLounges.where((l) =>
          l.name.toLowerCase().contains(_query.toLowerCase()) ||
          l.category.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ✅ Navigate to LoungeFeedScreen
  void _openLounge(Lounge lounge) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoungeFeedScreen(lounge: lounge)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPage,
      appBar: AppBar(
        backgroundColor: context.bgSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // ✅ Blur logo
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
              icon: Icon(Icons.search, color: context.txtMain),
              onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 80),
        children: [
          // ── Search bar ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: context.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: context.txtLight, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: TextStyle(fontSize: 13, color: context.txtMain),
                      decoration: InputDecoration(
                        hintText: 'Search for lounges, majors, or topics...',
                        hintStyle:
                            TextStyle(fontSize: 13, color: context.txtLight),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(Icons.close,
                            size: 16, color: context.txtLight),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Search results ────────────────────────────────────────────────
          if (_query.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_filtered.length} result${_filtered.length == 1 ? '' : 's'} for "$_query"',
                style: TextStyle(fontSize: 12, color: context.txtLight),
              ),
            ),
            const SizedBox(height: 10),
            ..._filtered.map((l) => _PopularLoungeCard(
                  lounge: l,
                  onTap: () => _openLounge(l), // ✅ navigates
                )),
          ] else ...[
            // ── Explore Lounges ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Explore Lounges',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.txtMain)),
                  Text('View All',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Grid cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UniversityTag(name: 'Academics'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _LoungeCard(
                          lounge: sampleLounges[0],
                          onTap: () => _openLounge(sampleLounges[0]), // ✅
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LoungeCard(
                          lounge: sampleLounges[1],
                          onTap: () => _openLounge(sampleLounges[1]), // ✅
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _LoungeCard(
                          lounge: sampleLounges[2],
                          onTap: () => _openLounge(sampleLounges[2]), // ✅
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LoungeCard(
                          lounge: sampleLounges[3],
                          onTap: () => _openLounge(sampleLounges[3]), // ✅
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Popular Campus Lounges ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Popular Campus Lounges',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.txtMain)),
            ),
            const SizedBox(height: 12),
            ...sampleLounges.map((l) => _PopularLoungeCard(
                  lounge: l,
                  onTap: () => _openLounge(l), // ✅
                )),
          ],
        ],
      ),
    );
  }
}

// ── Grid lounge card ──────────────────────────────────────────────────────────
class _LoungeCard extends StatelessWidget {
  final Lounge lounge;
  final VoidCallback onTap; // ✅ required
  const _LoungeCard({required this.lounge, required this.onTap});

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ tappable
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school_outlined,
                  color: AppTheme.primary, size: 18),
            ),
            const SizedBox(height: 10),
            Text(lounge.name,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.txtMain)),
            const SizedBox(height: 3),
            Text('${_fmt(lounge.members)} members',
                style: TextStyle(fontSize: 11, color: context.txtSub)),
          ],
        ),
      ),
    );
  }
}

// ── Popular lounge list card ──────────────────────────────────────────────────
class _PopularLoungeCard extends StatelessWidget {
  final Lounge lounge;
  final VoidCallback onTap; // ✅ required
  const _PopularLoungeCard({required this.lounge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ tappable
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chat_bubble_outline,
                  color: AppTheme.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lounge.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.txtMain)),
                  const SizedBox(height: 3),
                  Text(
                    '${lounge.university ?? ''} · ${lounge.posts} posts this week',
                    style: TextStyle(fontSize: 11.5, color: context.txtSub),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.txtLight),
          ],
        ),
      ),
    );
  }
}