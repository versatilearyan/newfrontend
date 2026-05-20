
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO OPEN THIS SCREEN (use showModalBottomSheet for drag-down dismiss):
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) => const CreatePostScreen(),
//   );
//
// OR push normally — swipe-right back gesture still works:
//   Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostScreen()));
// ─────────────────────────────────────────────────────────────────────────────

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with TickerProviderStateMixin {
  // ── Page controller for swipe between steps ──────────────────────────────
  late final PageController _pageCtrl;
  int _step = 0; // 0 = channel picker, 1 = write post
  Lounge? _selectedLounge;

  // ── Drag-down to dismiss ─────────────────────────────────────────────────
  late AnimationController _dragCtrl;
  double _dragOffset = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _dragCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _dragCtrl.dispose();
    super.dispose();
  }

  void _goToStep1(Lounge lounge) {
    setState(() {
      _selectedLounge = lounge;
      _step = 1;
    });
    _pageCtrl.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goBackToStep0() {
    setState(() => _step = 0);
    _pageCtrl.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ── Drag-down handlers ───────────────────────────────────────────────────
  void _onDragStart(DragStartDetails d) {
    _isDragging = true;
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_isDragging) return;
    setState(() {
      _dragOffset = (_dragOffset + d.delta.dy).clamp(0.0, 300.0);
    });
  }

  void _onDragEnd(DragEndDetails d) {
    _isDragging = false;
    if (_dragOffset > 120 || d.velocity.pixelsPerSecond.dy > 600) {
      // Dismiss
      Navigator.pop(context);
    } else {
      // Snap back
      setState(() => _dragOffset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _dragCtrl,
      builder: (_, __) {
        final progress = (_dragOffset / screenH).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, _dragOffset),
          child: Opacity(
            opacity: (1 - progress * 0.4).clamp(0.0, 1.0),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_dragOffset > 0 ? 20 : 0),
              ),
              child: Scaffold(
                backgroundColor: context.bgPage,
                body: Column(
                  children: [
                    // ── Drag handle (only when opened as modal) ───────────
                    GestureDetector(
                      onVerticalDragStart: _onDragStart,
                      onVerticalDragUpdate: _onDragUpdate,
                      onVerticalDragEnd: _onDragEnd,
                      child: Container(
                        width: double.infinity,
                        color: context.bgSurface,
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 8,
                          bottom: 8,
                        ),
                        child: Column(
                          children: [
                            // Drag pill
                            Container(
                              width: 36,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: context.border,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            // AppBar row
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              child: Row(
                                children: [
                                  // ✅ Back/close button
                                  IconButton(
                                    icon: Icon(
                                      _step == 0
                                          ? Icons.close
                                          : Icons.arrow_back,
                                      color: context.txtMain,
                                    ),
                                    onPressed: _step == 0
                                        ? () => Navigator.pop(context)
                                        : _goBackToStep0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _step == 0
                                          ? 'Post to:'
                                          : 'Create Post',
                                      style: TextStyle(
                                        fontSize: _step == 0 ? 20 : 17,
                                        fontWeight: FontWeight.w800,
                                        color: context.txtMain,
                                      ),
                                    ),
                                  ),
                                  // Post button (only on step 1)
                                  if (_step == 1)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8),
                                      child: _PostButton(
                                          lounge: _selectedLounge!),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── PageView — swipe right = go back ──────────────────
                    Expanded(
                      child: PageView(
                        controller: _pageCtrl,
                        physics:
                            const _SnapBackPhysics(), // swipe-right only on step 1
                        onPageChanged: (i) {
                          setState(() => _step = i);
                          if (i == 0) _selectedLounge = null;
                        },
                        children: [
                          // ── Page 0: Channel picker ────────────────────
                          _SelectChannelPage(
                            onChannelSelected: _goToStep1,
                          ),
                          // ── Page 1: Write post ────────────────────────
                          if (_selectedLounge != null)
                            _WritePostPage(
                              lounge: _selectedLounge!,
                              onBack: _goBackToStep0,
                            )
                          else
                            const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Custom scroll physics: allow swipe-right on step 1 to go back ─────────
class _SnapBackPhysics extends PageScrollPhysics {
  const _SnapBackPhysics();

  @override
  _SnapBackPhysics applyTo(ScrollPhysics? ancestor) =>
      const _SnapBackPhysics();
}

// ── Post button (disabled until content added) ─────────────────────────────
class _PostButton extends StatefulWidget {
  final Lounge lounge;
  const _PostButton({required this.lounge});

  @override
  State<_PostButton> createState() => _PostButtonState();
}

class _PostButtonState extends State<_PostButton> {
  void _publish() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✅ Posted to #${widget.lounge.name}'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppTheme.primary,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _publish,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('Post',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 0 — Channel Picker
// ═════════════════════════════════════════════════════════════════════════════
class _SelectChannelPage extends StatefulWidget {
  final void Function(Lounge) onChannelSelected;
  const _SelectChannelPage({required this.onChannelSelected});

  @override
  State<_SelectChannelPage> createState() => _SelectChannelPageState();
}

class _SelectChannelPageState extends State<_SelectChannelPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _colors = {
    'Academics':   Color(0xFF3B5BDB),
    'Social':      Color(0xFF7C3AED),
    'Housing':     Color(0xFF059669),
    'Career':      Color(0xFFD97706),
    'Rants':       Color(0xFFDC2626),
    'Memes':       Color(0xFFF97316),
    'Confessions': Color(0xFF0891B2),
    'General':     Color(0xFF6B7280),
    'Sports':      Color(0xFF16A34A),
    'Private':     Color(0xFF374151),
  };

  List<Lounge> get _my  => sampleLounges.take(2).toList();
  List<Lounge> get _fol => sampleLounges.skip(2).toList();

  List<Lounge> _filt(List<Lounge> l) => _query.isEmpty
      ? l
      : l.where((x) =>
              x.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();

  Color    _c(String cat) => _colors[cat] ?? AppTheme.primary;
  IconData _i(String cat) {
    switch (cat.toLowerCase()) {
      case 'academics':   return Icons.school_outlined;
      case 'social':      return Icons.people_outline;
      case 'sports':      return Icons.sports_outlined;
      case 'career':      return Icons.work_outline;
      case 'housing':     return Icons.home_outlined;
      case 'rants':       return Icons.mood_bad_outlined;
      case 'memes':       return Icons.sentiment_very_satisfied_outlined;
      case 'confessions': return Icons.chat_bubble_outline;
      case 'private':     return Icons.lock_outline;
      default:            return Icons.tag;
    }
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final my  = _filt(_my);
    final fol = _filt(_fol);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Container(
            decoration: BoxDecoration(
              color: context.bgCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.border),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(Icons.search, color: context.txtLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    style:
                        TextStyle(fontSize: 14, color: context.txtMain),
                    decoration: InputDecoration(
                      hintText: 'Search for channels',
                      hintStyle: TextStyle(
                          fontSize: 14, color: context.txtLight),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 13),
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              if (my.isNotEmpty) ...[
                _SH('My Channels'),
                ...my.map((l) => _CR(
                    lounge: l,
                    color: _c(l.category),
                    icon: _i(l.category),
                    onTap: () => widget.onChannelSelected(l))),
              ],
              if (fol.isNotEmpty) ...[
                _SH('Channels I Follow'),
                ...fol.map((l) => _CR(
                    lounge: l,
                    color: _c(l.category),
                    icon: _i(l.category),
                    onTap: () => widget.onChannelSelected(l))),
              ],
              if (my.isEmpty && fol.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Text('No channels found',
                        style: TextStyle(
                            fontSize: 14, color: context.txtLight)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SH extends StatelessWidget {
  final String t;
  const _SH(this.t);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        child: Text(t,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: context.txtSub)),
      );
}

class _CR extends StatelessWidget {
  final Lounge lounge;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _CR(
      {required this.lounge,
      required this.color,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lounge.name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: context.txtMain)),
                    const SizedBox(height: 2),
                    Text(
                      lounge.university != null
                          ? '${lounge.university} · ${lounge.category}'
                          : lounge.category,
                      style: TextStyle(
                          fontSize: 12, color: context.txtSub),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: context.txtLight, size: 18),
            ],
          ),
        ),
      );
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 1 — Write Post
// ═════════════════════════════════════════════════════════════════════════════
class _WritePostPage extends StatefulWidget {
  final Lounge lounge;
  final VoidCallback onBack;
  const _WritePostPage({required this.lounge, required this.onBack});

  @override
  State<_WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<_WritePostPage> {
  final _titleCtrl   = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _tagCtrl     = TextEditingController();
  int _charCount = 0;
  final List<File> _images = [];
  final _picker = ImagePicker();
  final List<String> _tags = [];

  static const _lc = {
    'Academics':   Color(0xFF3B5BDB),
    'Social':      Color(0xFF7C3AED),
    'Housing':     Color(0xFF059669),
    'Career':      Color(0xFFD97706),
    'Rants':       Color(0xFFDC2626),
    'Memes':       Color(0xFFF97316),
    'Confessions': Color(0xFF0891B2),
    'General':     Color(0xFF6B7280),
    'Sports':      Color(0xFF16A34A),
    'Private':     Color(0xFF374151),
  };

  Color get _loungeColor =>
      _lc[widget.lounge.category] ?? AppTheme.primary;

  @override
  void initState() {
    super.initState();
    _contentCtrl.addListener(
        () => setState(() => _charCount = _contentCtrl.text.length));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    HapticFeedback.lightImpact();
    try {
      final picked = await _picker.pickMultiImage(imageQuality: 85);
      if (picked.isNotEmpty && mounted) {
        setState(() {
          for (final xf in picked) {
            if (_images.length < 4) _images.add(File(xf.path));
          }
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Could not open gallery'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ));
      }
    }
  }

  void _showTagSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: context.bgCard,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add a tag',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.txtMain)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: context.bgPage,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary),
                ),
                child: TextField(
                  controller: _tagCtrl,
                  autofocus: true,
                  style:
                      TextStyle(fontSize: 14, color: context.txtMain),
                  decoration: InputDecoration(
                    hintText: 'e.g. Internship, Advice...',
                    hintStyle: TextStyle(
                        fontSize: 14, color: context.txtLight),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: InputBorder.none,
                    prefixText: '# ',
                    prefixStyle: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final t = _tagCtrl.text.trim();
                    if (t.isNotEmpty && !_tags.contains(t)) {
                      setState(() => _tags.add(t));
                    }
                    _tagCtrl.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Add Tag',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── User + channel chip ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnonAvatar(
                          size: 46,
                          initials: 'A',
                          bg: AppTheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Anonymous User',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: context.txtMain)),
                            const SizedBox(height: 6),
                            // ✅ Tap to go back and change channel
                            GestureDetector(
                              onTap: widget.onBack,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _loungeColor.withOpacity(0.12),
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('#${widget.lounge.name}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: _loungeColor)),
                                    const SizedBox(width: 4),
                                    Icon(
                                        Icons
                                            .keyboard_arrow_down_rounded,
                                        size: 14,
                                        color: _loungeColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Divider(
                    color: context.border,
                    height: 0.5,
                    thickness: 0.5),
                const SizedBox(height: 12),

                // ── TITLE ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text('TITLE',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: context.txtLight,
                          letterSpacing: 1.2)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _titleCtrl,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.txtMain),
                    decoration: InputDecoration(
                      hintText: 'Give your post a title...',
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: context.txtLight.withOpacity(0.45)),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),

                Divider(
                    color: context.border,
                    height: 1,
                    thickness: 0.5,
                    indent: 16,
                    endIndent: 16),
                const SizedBox(height: 8),

                // ── CONTENT ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text('CONTENT',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: context.txtLight,
                          letterSpacing: 1.2)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _contentCtrl,
                    style: TextStyle(
                        fontSize: 15,
                        color: context.txtMain,
                        height: 1.6),
                    decoration: InputDecoration(
                      hintText:
                          'Share your thoughts with your university community...',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: context.txtLight.withOpacity(0.45),
                          height: 1.6),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                    ),
                    maxLines: null,
                    minLines: 5,
                    maxLength: 3000,
                    buildCounter: (_, {required currentLength,
                          required isFocused,
                          maxLength}) =>
                        const SizedBox.shrink(),
                  ),
                ),

                // ── Image previews ───────────────────────────────────────
                if (_images.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _images.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10),
                              child: Image.file(
                                _images[i],
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4, right: 4,
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _images.removeAt(i)),
                                child: Container(
                                  width: 22, height: 22,
                                  decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.close,
                                      size: 13,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // ── Tags ─────────────────────────────────────────────────
                if (_tags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8, runSpacing: 6,
                      children: _tags
                          .map((t) => GestureDetector(
                                onTap: () =>
                                    setState(() => _tags.remove(t)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('#$t',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.primary,
                                              fontWeight:
                                                  FontWeight.w600)),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.close,
                                          size: 12,
                                          color: AppTheme.primary),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ── Campus Rules ─────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFF59E0B)
                              .withOpacity(0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: Color(0xFFD97706)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text('Campus Rules',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFD97706))),
                              const SizedBox(height: 4),
                              Text(
                                'Be respectful, stay anonymous, and keep it relevant to your university community. Posts that violate guidelines will be removed.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: context.isDark
                                        ? const Color(0xFFD97706)
                                        : const Color(0xFF92400E),
                                    height: 1.45),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Bottom toolbar ────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: context.bgSurface,
            border: Border(
                top: BorderSide(color: context.border, width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  _TB(
                    icon: Icons.image_outlined,
                    onTap: _images.length < 4 ? _pickImages : null,
                    badge:
                        _images.isNotEmpty ? '${_images.length}' : null,
                  ),
                  const SizedBox(width: 6),
                  _TB(icon: Icons.link_rounded, onTap: () {}),
                  const SizedBox(width: 6),
                  _TB(icon: Icons.bar_chart_rounded, onTap: () {}),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showTagSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add,
                              size: 14, color: AppTheme.primary),
                          SizedBox(width: 4),
                          Text('Add Tags',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('$_charCount / 3000',
                      style: TextStyle(
                          fontSize: 12,
                          color: _charCount > 2700
                              ? Colors.red
                              : context.txtLight)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Toolbar button ────────────────────────────────────────────────────────────
class _TB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? badge;
  const _TB({required this.icon, this.onTap, this.badge});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: context.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.border, width: 0.5),
              ),
              child: Icon(icon,
                  size: 20,
                  color: onTap == null
                      ? context.txtLight.withOpacity(0.4)
                      : context.txtSub),
            ),
            if (badge != null)
              Positioned(
                top: -4, right: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      color: AppTheme.primary, shape: BoxShape.circle),
                  child: Text(badge!,
                      style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
          ],
        ),
      );
}