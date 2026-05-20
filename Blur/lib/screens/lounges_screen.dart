// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../models/models.dart';
// import '../widgets/shared_widgets.dart';
// import 'lounge_feed_screen.dart';

// // ── Shared style helper ───────────────────────────────────────────────────────
// class LoungeStyle {
//   static const icons = {
//     'Confessions':   Icons.chat_bubble_outline,
//     'Romance':       Icons.favorite_outline,
//     'General':       Icons.nights_stay_outlined,
//     'Career':        Icons.work_outline,
//     'Academics':     Icons.school_outlined,
//     'Memes':         Icons.sentiment_very_satisfied_outlined,
//     'Housing':       Icons.home_outlined,
//     'Social':        Icons.people_outline,
//     'Wellness':      Icons.self_improvement_outlined,
//     'Rants':         Icons.mood_bad_outlined,
//     'Entertainment': Icons.music_note_outlined,
//     'Sports':        Icons.fitness_center_outlined,
//     'Lifestyle':     Icons.style_outlined,
//   };

//   static const colors = {
//     'Confessions':   Color(0xFF0891B2),
//     'Romance':       Color(0xFFEC4899),
//     'General':       Color(0xFF6366F1),
//     'Career':        Color(0xFFD97706),
//     'Academics':     Color(0xFF3B5BDB),
//     'Memes':         Color(0xFFF97316),
//     'Housing':       Color(0xFF059669),
//     'Social':        Color(0xFF7C3AED),
//     'Wellness':      Color(0xFF14B8A6),
//     'Rants':         Color(0xFFEF4444),
//     'Entertainment': Color(0xFF8B5CF6),
//     'Sports':        Color(0xFF16A34A),
//     'Lifestyle':     Color(0xFFDB2777),
//   };

//   // Gradient pairs for hero cards
//   static const gradients = {
//     'Confessions':   [Color(0xFF0369A1), Color(0xFF0891B2)],
//     'Romance':       [Color(0xFF9D174D), Color(0xFFEC4899)],
//     'General':       [Color(0xFF3730A3), Color(0xFF6366F1)],
//     'Career':        [Color(0xFF92400E), Color(0xFFD97706)],
//     'Academics':     [Color(0xFF1E3A8A), Color(0xFF3B5BDB)],
//     'Memes':         [Color(0xFFC2410C), Color(0xFFF97316)],
//     'Housing':       [Color(0xFF065F46), Color(0xFF059669)],
//     'Social':        [Color(0xFF4C1D95), Color(0xFF7C3AED)],
//     'Wellness':      [Color(0xFF134E4A), Color(0xFF14B8A6)],
//     'Rants':         [Color(0xFF991B1B), Color(0xFFEF4444)],
//     'Entertainment': [Color(0xFF4C1D95), Color(0xFF8B5CF6)],
//     'Sports':        [Color(0xFF14532D), Color(0xFF16A34A)],
//     'Lifestyle':     [Color(0xFF831843), Color(0xFFDB2777)],
//   };

//   static IconData iconFor(String cat) => icons[cat] ?? Icons.tag;
//   static Color colorFor(String cat) => colors[cat] ?? AppTheme.primary;
//   static List<Color> gradientFor(String cat) =>
//       gradients[cat] ?? [AppTheme.primary, AppTheme.primaryDark];

//   static String _fmt(int n) {
//     if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
//     if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
//     return '$n';
//   }
//   static String fmt(int n) => _fmt(n);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// class LoungesScreen extends StatefulWidget {
//   const LoungesScreen({super.key});

//   @override
//   State<LoungesScreen> createState() => _LoungesScreenState();
// }

// class _LoungesScreenState extends State<LoungesScreen> {
//   final _searchCtrl   = TextEditingController();
//   final _pageCtrl     = PageController(viewportFraction: 0.88);
//   String _query       = '';
//   String _selectedCat = 'All';
//   int    _heroPage    = 0;

//   List<String> get _categories {
//     final cats = sampleLounges.map((l) => l.category).toSet().toList()..sort();
//     return ['All', ...cats];
//   }

//   List<Lounge> get _filtered {
//     var list = sampleLounges;
//     if (_selectedCat != 'All') {
//       list = list.where((l) => l.category == _selectedCat).toList();
//     }
//     if (_query.isNotEmpty) {
//       list = list.where((l) =>
//           l.name.toLowerCase().contains(_query.toLowerCase()) ||
//           l.category.toLowerCase().contains(_query.toLowerCase())).toList();
//     }
//     return list;
//   }

//   // Top 5 → swipeable carousel
//   List<Lounge> get _heroLounges {
//     final s = [...sampleLounges]
//       ..sort((a, b) => b.members.compareTo(a.members));
//     return s.take(5).toList();
//   }

//   // Next 8 → horizontal scroll row
//   List<Lounge> get _featuredLounges {
//     final s = [...sampleLounges]
//       ..sort((a, b) => b.members.compareTo(a.members));
//     return s.skip(5).take(8).toList();
//   }

//   void _openLounge(Lounge l) => Navigator.push(context,
//       MaterialPageRoute(builder: (_) => LoungeFeedScreen(lounge: l)));

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     _pageCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSearching = _query.isNotEmpty;
//     final isFiltered  = _selectedCat != 'All';

//     return Scaffold(
//       backgroundColor: context.bgPage,
//       body: CustomScrollView(
//         slivers: [
//           // ── Sticky AppBar ─────────────────────────────────────────────
//           SliverAppBar(
//             pinned: true,
//             floating: true,
//             snap: true,
//             backgroundColor: context.bgSurface,
//             surfaceTintColor: Colors.transparent,
//             elevation: 0,
//             automaticallyImplyLeading: false,
//             title: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(7),
//                   child: Image.asset(
//                     'assets/images/blur_logo.png',
//                     width: 28, height: 28, fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       width: 28, height: 28,
//                       decoration: BoxDecoration(
//                           color: AppTheme.primary,
//                           borderRadius: BorderRadius.circular(7)),
//                       child: const Center(
//                         child: Text('b',
//                             style: TextStyle(color: Colors.white,
//                                 fontWeight: FontWeight.w800, fontSize: 14)),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text('Lounges',
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w800,
//                         color: context.txtMain)),
//               ],
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.search, color: context.txtMain),
//                 onPressed: () {},
//               ),
//             ],
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(52),
//               child: _SearchBar(
//                 ctrl: _searchCtrl,
//                 query: _query,
//                 onChanged: (v) => setState(() {
//                   _query = v;
//                   if (v.isNotEmpty) _selectedCat = 'All';
//                 }),
//                 onClear: () {
//                   _searchCtrl.clear();
//                   setState(() => _query = '');
//                 },
//               ),
//             ),
//           ),

//           // ── Category chips ────────────────────────────────────────────
//           if (!isSearching)
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 14, bottom: 4),
//                 child: SizedBox(
//                   height: 36,
//                   child: ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: _categories.length,
//                     separatorBuilder: (_, __) => const SizedBox(width: 8),
//                     itemBuilder: (_, i) {
//                       final cat = _categories[i];
//                       final sel = _selectedCat == cat;
//                       final c = cat == 'All'
//                           ? AppTheme.primary
//                           : LoungeStyle.colorFor(cat);
//                       return GestureDetector(
//                         onTap: () => setState(() => _selectedCat = cat),
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 180),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 7),
//                           decoration: BoxDecoration(
//                             color: sel ? c : c.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(cat,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: sel ? Colors.white : c)),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//           // ── Search / Filter results ───────────────────────────────────
//           if (isSearching || isFiltered) ...[
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                 child: Row(
//                   children: [
//                     Text(
//                       isSearching
//                           ? '${_filtered.length} results for "$_query"'
//                           : '$_selectedCat · ${_filtered.length} lounges',
//                       style: TextStyle(
//                           fontSize: 13, color: context.txtSub),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (_, i) => _LoungeRow(
//                     lounge: _filtered[i],
//                     onTap: () => _openLounge(_filtered[i])),
//                 childCount: _filtered.length,
//               ),
//             ),
//           ]

//           // ── Default view ──────────────────────────────────────────────
//           else ...[
//             // ── Hero carousel ────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: _SectionHeader(
//                       title: 'Most Active',
//                       subtitle: 'Swipe to explore',
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // ✅ Swipeable PageView carousel
//                   SizedBox(
//                     height: 170,
//                     child: PageView.builder(
//                       controller: _pageCtrl,
//                       itemCount: _heroLounges.length,
//                       onPageChanged: (i) => setState(() => _heroPage = i),
//                       itemBuilder: (_, i) {
//                         final l = _heroLounges[i];
//                         return Padding(
//                           padding: EdgeInsets.only(
//                             left: i == 0 ? 16 : 8,
//                             right: i == _heroLounges.length - 1 ? 16 : 8,
//                           ),
//                           child: _HeroCard(
//                             lounge: l,
//                             onTap: () => _openLounge(l),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   // ✅ Dot indicators
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(_heroLounges.length, (i) {
//                       final active = i == _heroPage;
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 250),
//                         margin: const EdgeInsets.symmetric(horizontal: 3),
//                         width: active ? 20 : 6,
//                         height: 6,
//                         decoration: BoxDecoration(
//                           color: active
//                               ? AppTheme.primary
//                               : AppTheme.primary.withOpacity(0.25),
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                       );
//                     }),
//                   ),

//                   // ── Featured horizontal scroll ──────────────────────
//                   const SizedBox(height: 24),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: _SectionHeader(
//                       title: 'Trending',
//                       subtitle: 'Most popular this week',
//                       action: 'See all',
//                       onAction: () {},
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // ✅ Horizontal scroll row (peek next card)
//                   SizedBox(
//                     height: 200,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: _featuredLounges.length,
//                       itemBuilder: (_, i) => Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: _FeaturedCard(
//                           lounge: _featuredLounges[i],
//                           onTap: () => _openLounge(_featuredLounges[i]),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // ── All Lounges header ──────────────────────────────
//                   const SizedBox(height: 24),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: _SectionHeader(
//                       title: 'All Lounges',
//                       subtitle: '${sampleLounges.length} communities',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),

//             // Full list
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (_, i) => _LoungeRow(
//                     lounge: sampleLounges[i],
//                     onTap: () => _openLounge(sampleLounges[i])),
//                 childCount: sampleLounges.length,
//               ),
//             ),

//             const SliverToBoxAdapter(child: SizedBox(height: 100)),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ── Search bar ────────────────────────────────────────────────────────────────
// class _SearchBar extends StatelessWidget {
//   final TextEditingController ctrl;
//   final String query;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onClear;

//   const _SearchBar({
//     required this.ctrl,
//     required this.query,
//     required this.onChanged,
//     required this.onClear,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
//       child: Container(
//         height: 42,
//         decoration: BoxDecoration(
//           color: context.bgCard,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: context.border),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 12),
//             Icon(Icons.search, color: context.txtLight, size: 18),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: ctrl,
//                 style: TextStyle(fontSize: 13.5, color: context.txtMain),
//                 decoration: InputDecoration(
//                   hintText: 'Search lounges, topics, moods...',
//                   hintStyle:
//                       TextStyle(fontSize: 13.5, color: context.txtLight),
//                   border: InputBorder.none,
//                   isDense: true,
//                   contentPadding: EdgeInsets.zero,
//                 ),
//                 onChanged: onChanged,
//               ),
//             ),
//             if (query.isNotEmpty)
//               GestureDetector(
//                 onTap: onClear,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10),
//                   child: Icon(Icons.close, size: 16, color: context.txtLight),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Section header ────────────────────────────────────────────────────────────
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final String? action;
//   final VoidCallback? onAction;

//   const _SectionHeader({
//     required this.title,
//     this.subtitle,
//     this.action,
//     this.onAction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title,
//                   style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w800,
//                       color: context.txtMain)),
//               if (subtitle != null)
//                 Text(subtitle!,
//                     style: TextStyle(fontSize: 12, color: context.txtSub)),
//             ],
//           ),
//         ),
//         if (action != null)
//           GestureDetector(
//             onTap: onAction,
//             child: Text(action!,
//                 style: const TextStyle(
//                     fontSize: 13,
//                     color: AppTheme.primary,
//                     fontWeight: FontWeight.w600)),
//           ),
//       ],
//     );
//   }
// }

// class _FeaturedCard extends StatelessWidget {
//   final Lounge lounge;
//   final VoidCallback onTap;
//   const _FeaturedCard({required this.lounge, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final color = LoungeStyle.colorFor(lounge.category);
//     final icon  = LoungeStyle.iconFor(lounge.category);
//     final grad  = LoungeStyle.gradientFor(lounge.category);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 150,                        // ✅ fixed width for horizontal ListView
//         decoration: BoxDecoration(
//           color: context.bgCard,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: context.border, width: 0.5),
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Banner image ──────────────────────────────────────────
//             SizedBox(
//               height: 90,
//               width: double.infinity,
//               child: Stack(
//                 children: [
//                   // Image or gradient fallback
//                   SizedBox.expand(
//                     child: lounge.imageUrl != null
//                         ? Image.network(
//                             lounge.imageUrl!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => DecoratedBox(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: grad,
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                               ),
//                             ),
//                             loadingBuilder: (_, child, prog) => prog == null
//                                 ? child
//                                 : DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: grad,
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                     ),
//                                   ),
//                           )
//                         : DecoratedBox(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: grad,
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                             ),
//                           ),
//                   ),
//                   // Dark overlay at bottom for contrast
//                   Positioned(
//                     left: 0, right: 0, bottom: 0,
//                     height: 30,
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             context.bgCard.withOpacity(0.85),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ── Info ──────────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // Category icon
//                       Container(
//                         width: 32, height: 32,
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.12),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(icon, color: color, size: 16),
//                       ),
//                       const Spacer(),
//                       Icon(Icons.arrow_forward_ios,
//                           size: 11, color: context.txtLight),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(lounge.name,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w700,
//                           color: context.txtMain)),
//                   const SizedBox(height: 3),
//                   Text(
//                     '${LoungeStyle.fmt(lounge.members)} members',
//                     style: TextStyle(fontSize: 11, color: context.txtSub),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Hero Card for carousel ────────────────────────────────────────────────────
// class _HeroCard extends StatelessWidget {
//   final Lounge lounge;
//   final VoidCallback onTap;
//   const _HeroCard({required this.lounge, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final grad = LoungeStyle.gradientFor(lounge.category);
//     final icon = LoungeStyle.iconFor(lounge.category);
//     final color = LoungeStyle.colorFor(lounge.category);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: grad,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: grad.last.withOpacity(0.18),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Banner image (if available)
//             if (lounge.imageUrl != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.network(
//                   lounge.imageUrl!,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: double.infinity,
//                   color: Colors.black.withOpacity(0.18),
//                   colorBlendMode: BlendMode.darken,
//                   errorBuilder: (_, __, ___) => const SizedBox(),
//                 ),
//               ),
//             // Overlay gradient for readability
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.10),
//                     Colors.black.withOpacity(0.18),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//             // Content
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Category icon
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(icon, color: color, size: 22),
//                   ),
//                   const SizedBox(height: 14),
//                   Text(
//                     lounge.name,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w800,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black26,
//                           blurRadius: 2,
//                           offset: Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   Row(
//                     children: [
//                       Icon(Icons.people_outline, color: Colors.white70, size: 15),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${LoungeStyle.fmt(lounge.members)} members',
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       Icon(Icons.bolt_outlined, color: Colors.white70, size: 15),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${lounge.posts} posts/wk',
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Full list row ─────────────────────────────────────────────────────────────
// class _LoungeRow extends StatelessWidget {
//   final Lounge lounge;
//   final VoidCallback onTap;
//   const _LoungeRow({required this.lounge, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final color = LoungeStyle.colorFor(lounge.category);
//     final icon  = LoungeStyle.iconFor(lounge.category);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//         decoration: BoxDecoration(
//           color: context.bgCard,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: context.border, width: 0.5),
//         ),
//         child: Row(
//           children: [
//             // Icon
//             Container(
//               width: 48, height: 48,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 22),
//             ),
//             const SizedBox(width: 14),

//             // Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(lounge.name,
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 color: context.txtMain)),
//                       ),
//                       const SizedBox(width: 6),
//                       // Category chip
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(lounge.category,
//                             style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                                 color: color)),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Icon(Icons.people_outline,
//                           size: 12, color: context.txtLight),
//                       const SizedBox(width: 3),
//                       Text(
//                         '${LoungeStyle.fmt(lounge.members)} members',
//                         style: TextStyle(
//                             fontSize: 12, color: context.txtSub),
//                       ),
//                       const SizedBox(width: 12),
//                       Icon(Icons.bolt_outlined,
//                           size: 12, color: context.txtLight),
//                       const SizedBox(width: 3),
//                       Text(
//                         '${lounge.posts} posts/wk',
//                         style: TextStyle(
//                             fontSize: 12, color: context.txtSub),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 6),
//             Icon(Icons.chevron_right,
//                 color: context.txtLight, size: 18),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'lounge_feed_screen.dart';

// ── Shared style helper ───────────────────────────────────────────────────────
class LoungeStyle {
  static const icons = {
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
  };

  static const colors = {
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
  };

  static const gradients = {
    'Confessions':   [Color(0xFF0369A1), Color(0xFF0891B2)],
    'Romance':       [Color(0xFF9D174D), Color(0xFFEC4899)],
    'General':       [Color(0xFF3730A3), Color(0xFF6366F1)],
    'Career':        [Color(0xFF92400E), Color(0xFFD97706)],
    'Academics':     [Color(0xFF1E3A8A), Color(0xFF3B5BDB)],
    'Memes':         [Color(0xFFC2410C), Color(0xFFF97316)],
    'Housing':       [Color(0xFF065F46), Color(0xFF059669)],
    'Social':        [Color(0xFF4C1D95), Color(0xFF7C3AED)],
    'Wellness':      [Color(0xFF134E4A), Color(0xFF14B8A6)],
    'Rants':         [Color(0xFF991B1B), Color(0xFFEF4444)],
    'Entertainment': [Color(0xFF4C1D95), Color(0xFF8B5CF6)],
    'Sports':        [Color(0xFF14532D), Color(0xFF16A34A)],
    'Lifestyle':     [Color(0xFF831843), Color(0xFFDB2777)],
  };

  static IconData iconFor(String cat) => icons[cat] ?? Icons.tag;
  static Color colorFor(String cat) => colors[cat] ?? AppTheme.primary;
  static List<Color> gradientFor(String cat) =>
      gradients[cat] ?? [AppTheme.primary, AppTheme.primaryDark];

  static String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
  static String fmt(int n) => _fmt(n);
}

// ── Profile photo widget — reused in both cards ────────────────────────────
class _LoungeAvatar extends StatelessWidget {
  final Lounge lounge;
  final double radius;

  const _LoungeAvatar({
    required this.lounge,
    // ignore: unused_element_parameter
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final color = LoungeStyle.colorFor(lounge.category);
    final icon  = LoungeStyle.iconFor(lounge.category);

    final double size = 40;

    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: lounge.profileImageUrl != null
            ? Image.network(
                lounge.profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(icon, color: color, size: size * 0.5),
                loadingBuilder: (_, child, prog) =>
                    prog == null ? child : Icon(icon, color: color, size: size * 0.5),
              )
            : Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class LoungesScreen extends StatefulWidget {
  const LoungesScreen({super.key});

  @override
  State<LoungesScreen> createState() => _LoungesScreenState();
}

class _LoungesScreenState extends State<LoungesScreen> {
  final _searchCtrl   = TextEditingController();
  final _pageCtrl     = PageController(viewportFraction: 0.88);
  String _query       = '';
  String _selectedCat = 'All';
  int    _heroPage    = 0;

  List<String> get _categories {
    final cats = sampleLounges.map((l) => l.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  List<Lounge> get _filtered {
    var list = sampleLounges;
    if (_selectedCat != 'All') {
      list = list.where((l) => l.category == _selectedCat).toList();
    }
    if (_query.isNotEmpty) {
      list = list.where((l) =>
          l.name.toLowerCase().contains(_query.toLowerCase()) ||
          l.category.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    return list;
  }

  List<Lounge> get _heroLounges {
    final s = [...sampleLounges]
      ..sort((a, b) => b.members.compareTo(a.members));
    return s.take(5).toList();
  }

  List<Lounge> get _featuredLounges {
    final s = [...sampleLounges]
      ..sort((a, b) => b.members.compareTo(a.members));
    return s.skip(5).take(8).toList();
  }

  void _openLounge(Lounge l) => Navigator.push(context,
      MaterialPageRoute(builder: (_) => LoungeFeedScreen(lounge: l)));

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _query.isNotEmpty;
    final isFiltered  = _selectedCat != 'All';

    return Scaffold(
      backgroundColor: context.bgPage,
      body: CustomScrollView(
        slivers: [
          // ── Sticky AppBar ─────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: context.bgSurface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    'assets/images/blur_logo.png',
                    width: 28, height: 28, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(7)),
                      child: const Center(
                        child: Text('b',
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w800, fontSize: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Lounges',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: context.txtMain)),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: context.txtMain),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: _SearchBar(
                ctrl: _searchCtrl,
                query: _query,
                onChanged: (v) => setState(() {
                  _query = v;
                  if (v.isNotEmpty) _selectedCat = 'All';
                }),
                onClear: () {
                  _searchCtrl.clear();
                  setState(() => _query = '');
                },
              ),
            ),
          ),

          // ── Category chips ────────────────────────────────────────────
          if (!isSearching)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 4),
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = _categories[i];
                      final sel = _selectedCat == cat;
                      final c = cat == 'All'
                          ? AppTheme.primary
                          : LoungeStyle.colorFor(cat);
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCat = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: sel ? c : c.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(cat,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: sel ? Colors.white : c)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // ── Search / Filter results ───────────────────────────────────
          if (isSearching || isFiltered) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  isSearching
                      ? '${_filtered.length} results for "$_query"'
                      : '$_selectedCat · ${_filtered.length} lounges',
                  style: TextStyle(fontSize: 13, color: context.txtSub),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _LoungeRow(
                    lounge: _filtered[i],
                    onTap: () => _openLounge(_filtered[i])),
                childCount: _filtered.length,
              ),
            ),
          ]

          // ── Default view ──────────────────────────────────────────────
          else ...[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionHeader(
                        title: 'Most Active', subtitle: 'Swipe to explore'),
                  ),
                  const SizedBox(height: 12),

                  // ── Swipeable carousel ──────────────────────────────
                  SizedBox(
                    height: 170,
                    child: PageView.builder(
                      controller: _pageCtrl,
                      itemCount: _heroLounges.length,
                      onPageChanged: (i) => setState(() => _heroPage = i),
                      itemBuilder: (_, i) {
                        final l = _heroLounges[i];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: i == 0 ? 16 : 8,
                            right: i == _heroLounges.length - 1 ? 16 : 8,
                          ),
                          child: _HeroCard(lounge: l, onTap: () => _openLounge(l)),
                        );
                      },
                    ),
                  ),

                  // ── Dot indicators ──────────────────────────────────
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_heroLounges.length, (i) {
                      final active = i == _heroPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? AppTheme.primary
                              : AppTheme.primary.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  // ── Featured horizontal scroll ──────────────────────
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionHeader(
                      title: 'Trending',
                      subtitle: 'Most popular this week',
                      action: 'See all',
                      onAction: () {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _featuredLounges.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _FeaturedCard(
                          lounge: _featuredLounges[i],
                          onTap: () => _openLounge(_featuredLounges[i]),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionHeader(
                      title: 'All Lounges',
                      subtitle: '${sampleLounges.length} communities',
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _LoungeRow(
                    lounge: sampleLounges[i],
                    onTap: () => _openLounge(sampleLounges[i])),
                childCount: sampleLounges.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController ctrl;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _SearchBar({required this.ctrl, required this.query,
      required this.onChanged, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.search, color: context.txtLight, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: ctrl,
                style: TextStyle(fontSize: 13.5, color: context.txtMain),
                decoration: InputDecoration(
                  hintText: 'Search lounges, topics, moods...',
                  hintStyle: TextStyle(fontSize: 13.5, color: context.txtLight),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: onChanged,
              ),
            ),
            if (query.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.close, size: 16, color: context.txtLight),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, this.subtitle,
      this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: context.txtMain)),
              if (subtitle != null)
                Text(subtitle!,
                    style: TextStyle(fontSize: 12, color: context.txtSub)),
            ],
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

// ── Hero Card (carousel) ──────────────────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  final Lounge lounge;
  final VoidCallback onTap;
  const _HeroCard({required this.lounge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final grad  = LoungeStyle.gradientFor(lounge.category);
    final color = LoungeStyle.colorFor(lounge.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: grad,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: grad.last.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Stack(
          children: [
            // Banner image
            if (lounge.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  lounge.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.18),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.18),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Profile photo avatar
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.4), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: lounge.profileImageUrl != null
                          ? Image.network(
                              lounge.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: color.withOpacity(0.4),
                                child: Icon(
                                    LoungeStyle.iconFor(lounge.category),
                                    color: Colors.white, size: 20),
                              ),
                              loadingBuilder: (_, child, prog) =>
                                  prog == null ? child : Container(
                                    color: color.withOpacity(0.3),
                                    child: Icon(
                                        LoungeStyle.iconFor(lounge.category),
                                        color: Colors.white, size: 20),
                                  ),
                            )
                          : Container(
                              color: color.withOpacity(0.3),
                              child: Icon(
                                  LoungeStyle.iconFor(lounge.category),
                                  color: Colors.white, size: 20),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lounge.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black26,
                          blurRadius: 2, offset: Offset(0, 1))],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.people_outline,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text('${LoungeStyle.fmt(lounge.members)} members',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.bolt_outlined,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text('${lounge.posts} posts/wk',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Featured Card (horizontal scroll) ────────────────────────────────────────
class _FeaturedCard extends StatelessWidget {
  final Lounge lounge;
  final VoidCallback onTap;
  const _FeaturedCard({required this.lounge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = LoungeStyle.colorFor(lounge.category);
    final grad  = LoungeStyle.gradientFor(lounge.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.border, width: 0.5),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Banner ───────────────────────────────────────────────
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: lounge.imageUrl != null
                        ? Image.network(lounge.imageUrl!, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: grad,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            ),
                            loadingBuilder: (_, child, prog) => prog == null
                                ? child
                                : DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: grad,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                  ))
                        : DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: grad,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))),
                  ),
                  Positioned(
                    left: 0, right: 0, bottom: 0, height: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            context.bgCard.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // ✅ Profile photo avatar (replaces icon)
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: lounge.profileImageUrl != null
                              ? Image.network(
                                  lounge.profileImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(LoungeStyle.iconFor(lounge.category),
                                          color: color, size: 16),
                                  loadingBuilder: (_, child, prog) =>
                                      prog == null ? child :
                                      Icon(LoungeStyle.iconFor(lounge.category),
                                          color: color, size: 16),
                                )
                              : Icon(LoungeStyle.iconFor(lounge.category),
                                  color: color, size: 16),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 11, color: context.txtLight),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(lounge.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.txtMain)),
                  const SizedBox(height: 3),
                  Text('${LoungeStyle.fmt(lounge.members)} members',
                      style: TextStyle(fontSize: 11, color: context.txtSub)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Full list row ─────────────────────────────────────────────────────────────
class _LoungeRow extends StatelessWidget {
  final Lounge lounge;
  final VoidCallback onTap;
  const _LoungeRow({required this.lounge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = LoungeStyle.colorFor(lounge.category);
    final icon  = LoungeStyle.iconFor(lounge.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.border, width: 0.5),
        ),
        child: Row(
          children: [
            // ✅ Profile photo avatar
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: lounge.profileImageUrl != null
                    ? Image.network(lounge.profileImageUrl!, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(icon, color: color, size: 22),
                        loadingBuilder: (_, child, prog) =>
                            prog == null ? child : Icon(icon, color: color, size: 22))
                    : Icon(icon, color: color, size: 22),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(lounge.name,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: context.txtMain)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(lounge.category,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: color)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: 12, color: context.txtLight),
                      const SizedBox(width: 3),
                      Text('${LoungeStyle.fmt(lounge.members)} members',
                          style: TextStyle(fontSize: 12, color: context.txtSub)),
                      const SizedBox(width: 12),
                      Icon(Icons.bolt_outlined,
                          size: 12, color: context.txtLight),
                      const SizedBox(width: 3),
                      Text('${lounge.posts} posts/wk',
                          style: TextStyle(fontSize: 12, color: context.txtSub)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: context.txtLight, size: 18),
          ],
        ),
      ),
    );
  }
}