import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ── Entry point: Lounge Picker (Screen 1) ─────────────────────────────────────
class CreatePostScreen extends StatefulWidget {
  final Lounge? preselectedLounge; // optional — pass from LoungeFeedScreen
  const CreatePostScreen({super.key, this.preselectedLounge});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  // Lounges from sampleLounges — same data as LoungesScreen
  List<Lounge> get _myChannels =>
      sampleLounges.where((l) => l.category != 'General').toList();


  List<Lounge> get _filtered {
    if (_query.isEmpty) return sampleLounges;
    return sampleLounges
        .where((l) =>
            l.name.toLowerCase().contains(_query.toLowerCase()) ||
            l.category.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // If preselected, skip picker and go straight to compose
    if (widget.preselectedLounge != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openCompose(widget.preselectedLounge!);
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openCompose(Lounge lounge) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _ComposePostScreen(lounge: lounge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPage,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle bar ─────────────────────────────────────────────────
            Center(
              child: Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                decoration: BoxDecoration(
                  color: context.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Title ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text('Post to:',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: context.txtMain)),
            ),

            // ── Search bar ─────────────────────────────────────────────────
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
                        style:
                            TextStyle(fontSize: 14, color: context.txtMain),
                        decoration: InputDecoration(
                          hintText: 'Search for channels',
                          hintStyle: TextStyle(
                              fontSize: 14, color: context.txtLight),
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
            const SizedBox(height: 16),

            // ── Channel list ───────────────────────────────────────────────
            Expanded(
              child: _query.isNotEmpty
                  ? _buildSearchResults()
                  : _buildChannelSections(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = _filtered;
    if (results.isEmpty) {
      return Center(
        child: Text('No channels found',
            style: TextStyle(color: context.txtLight)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 32),
      itemCount: results.length,
      itemBuilder: (_, i) => _ChannelPickerTile(
        lounge: results[i],
        onTap: () => _openCompose(results[i]),
      ),
    );
  }

  Widget _buildChannelSections() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        // My Channels (non-general lounges)
        if (_myChannels.isNotEmpty) ...[
          _SectionLabel(label: 'My Channels'),
          ..._myChannels.map((l) => _ChannelPickerTile(
                lounge: l,
                onTap: () => _openCompose(l),
              )),
          const SizedBox(height: 8),
        ],

        // Channels I Follow (general)
        _SectionLabel(label: 'Channels I Follow'),
        ...sampleLounges.map((l) => _ChannelPickerTile(
              lounge: l,
              onTap: () => _openCompose(l),
            )),
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Text(label,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.txtSub,
              letterSpacing: 0.3)),
    );
  }
}

// ── Channel picker tile ───────────────────────────────────────────────────────
class _ChannelPickerTile extends StatelessWidget {
  final Lounge lounge;
  final VoidCallback onTap;
  const _ChannelPickerTile({required this.lounge, required this.onTap});

  Color _catColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'academics': return const Color(0xFF3B5BDB);
      case 'social':    return const Color(0xFF7C3AED);
      case 'housing':   return const Color(0xFF059669);
      case 'career':    return const Color(0xFFD97706);
      case 'rants':     return const Color(0xFFDC2626);
      default:          return AppTheme.primary;
    }
  }

  String _fmt(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    final c = _catColor(lounge.category);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Icon avatar
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: c.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  lounge.name[0].toUpperCase(),
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800, color: c),
                ),
              ),
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
                    '${lounge.university ?? lounge.category} · ${_fmt(lounge.members)} members',
                    style: TextStyle(fontSize: 12, color: context.txtSub),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.txtLight, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Screen 2: Compose post ────────────────────────────────────────────────────
class _ComposePostScreen extends StatefulWidget {
  final Lounge lounge;
  const _ComposePostScreen({required this.lounge});

  @override
  State<_ComposePostScreen> createState() => _ComposePostScreenState();
}

class _ComposePostScreenState extends State<_ComposePostScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  int _charCount = 0;
  final List<XFile> _images = [];
  final _picker = ImagePicker();

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
    super.dispose();
  }

  bool get _canPost => _contentCtrl.text.trim().isNotEmpty;

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked);
        if (_images.length > 4) _images.removeRange(4, _images.length);
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final picked =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null && _images.length < 4) {
      setState(() => _images.add(picked));
    }
  }

  void _submit() {
    if (!_canPost) return;
    Navigator.pop(context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✅ Posted to ${widget.lounge.name}!'),
      backgroundColor: AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final lounge = widget.lounge;

    return Scaffold(
      backgroundColor: context.bgSurface,
      appBar: AppBar(
        backgroundColor: context.bgSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.txtMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create Post',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.txtMain)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _canPost ? _submit : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: _canPost
                      ? AppTheme.primary
                      : AppTheme.primary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Post',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── User + lounge chip ──────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                    color: AppTheme.primary, shape: BoxShape.circle),
                child: const Center(
                  child: Text('A',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Anonymous User',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.txtMain)),
                    const Text('📍 STANFORD UNIVERSITY',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary)),
                  ],
                ),
              ),
              // Selected lounge chip — tappable to go back
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(lounge.name,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary)),
                      const SizedBox(width: 4),
                      const Icon(Icons.expand_more,
                          size: 14, color: AppTheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Title ───────────────────────────────────────────────────────
          Text('TITLE',
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: context.txtSub)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.txtMain),
            decoration: InputDecoration(
              hintText: 'Give your post a title...',
              hintStyle:
                  TextStyle(color: context.txtLight, fontSize: 15),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Divider(color: context.border),
          const SizedBox(height: 12),

          // ── Content ─────────────────────────────────────────────────────
          Text('CONTENT',
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: context.txtSub)),
          const SizedBox(height: 8),
          TextField(
            controller: _contentCtrl,
            maxLines: 8,
            style: TextStyle(
                fontSize: 14, color: context.txtMain, height: 1.6),
            decoration: InputDecoration(
              hintText:
                  'Share your thoughts with your university community...',
              hintStyle:
                  TextStyle(color: context.txtLight, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),

          // ── Image previews ───────────────────────────────────────────────
          if (_images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (_, i) => Stack(
                  children: [
                    Container(
                      width: 80, height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(File(_images[i].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4, right: 12,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _images.removeAt(i)),
                        child: Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // ── Toolbar ──────────────────────────────────────────────────────
          Row(
            children: [
              // Gallery
              GestureDetector(
                onTap: _images.length < 4 ? _pickImages : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.image_outlined,
                        size: 24,
                        color: _images.isNotEmpty
                            ? AppTheme.primary
                            : context.txtLight),
                    if (_images.isNotEmpty)
                      Positioned(
                        top: -4, right: -4,
                        child: Container(
                          width: 14, height: 14,
                          decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Text('${_images.length}',
                                style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              // Camera
              GestureDetector(
                onTap: _images.length < 4 ? _pickFromCamera : null,
                child: Icon(Icons.camera_alt_outlined,
                    size: 24, color: context.txtLight),
              ),
              const SizedBox(width: 18),
              Icon(Icons.link, size: 24, color: context.txtLight),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 14, color: AppTheme.primary),
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
              const SizedBox(width: 10),
              Text('$_charCount / 3000',
                  style: TextStyle(
                      fontSize: 12, color: context.txtLight)),
            ],
          ),
          Divider(color: context.border, height: 24),

          // ── Campus rules ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.isDark
                  ? const Color(0xFF2D1F00)
                  : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.isDark
                    ? const Color(0xFF78450A)
                    : const Color(0xFFFDE68A),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 14, color: Color(0xFFD97706)),
                    SizedBox(width: 6),
                    Text('Campus Rules',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD97706))),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Be respectful, stay anonymous, and keep it relevant to your university community. Posts that violate guidelines will be removed.',
                  style: TextStyle(
                      fontSize: 12,
                      color: context.isDark
                          ? const Color(0xFFD97706)
                          : const Color(0xFF92400E),
                      height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}