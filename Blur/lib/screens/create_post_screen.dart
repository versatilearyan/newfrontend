import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  String _selectedLounge = 'Academics';
  bool _postAnonymously = true;
  int _charCount = 0;

  final _lounges = ['Academics', 'Social', 'Housing', 'Career', 'Rants'];
  // ignore: unused_field
  final _tags = ['#Internship', '#CampusLife', '#Advice', '#Question'];

  static const _loungeColors = {
    'Academics': Color(0xFF3B5BDB),
    'Social': Color(0xFF7C3AED),
    'Housing': Color(0xFF059669),
    'Career': Color(0xFFD97706),
    'Rants': Color(0xFFDC2626),
  };

  @override
  void initState() {
    super.initState();
    _contentCtrl.addListener(() {
      setState(() => _charCount = _contentCtrl.text.length);
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _contentCtrl.text.isNotEmpty
                  ? () => Navigator.pop(context)
                  : null,
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Post',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // User row
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
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
                    Row(
                      children: [
                        const Text('📍 STANFORD UNIVERSITY',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text('Post',
                      style: TextStyle(fontSize: 12, color: context.txtSub)),
                  const SizedBox(width: 6),
                  Switch(
                    value: _postAnonymously,
                    onChanged: (v) => setState(() => _postAnonymously = v),
                    activeColor: AppTheme.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Select lounge
          Text('SELECT LOUNGE',
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: context.txtSub)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _lounges.map((l) {
                final selected = l == _selectedLounge;
                final color = _loungeColors[l] ?? AppTheme.primary;
                return GestureDetector(
                  onTap: () => setState(() => _selectedLounge = l),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? color : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(l,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : color)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Title
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

          // Content
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
                fontSize: 14,
                color: context.txtMain,
                height: 1.6),
            decoration: InputDecoration(
              hintText: 'Share your thoughts with your university community...',
              hintStyle:
                  TextStyle(color: context.txtLight, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 12),

          // Toolbar
          Row(
            children: [
              Icon(Icons.image_outlined,
                  size: 22, color: context.txtLight),
              const SizedBox(width: 16),
              Icon(Icons.link, size: 22, color: context.txtLight),
              const SizedBox(width: 16),
              Icon(Icons.poll_outlined,
                  size: 22, color: context.txtLight),
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

          // Campus rules
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: Color(0xFFD97706)),
                    const SizedBox(width: 6),
                    const Text('Campus Rules',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD97706))),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Be respectful, stay anonymous, and keep it relevant to your university community. Posts that violate guidelines will be removed.',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF92400E),
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}