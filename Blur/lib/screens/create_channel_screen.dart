import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/channel_model.dart';

class CreateChannelScreen extends StatefulWidget {
  final void Function(ChannelModel newChannel) onChannelCreated;

  const CreateChannelScreen({
    super.key,
    required this.onChannelCreated,
  });

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _questionCtrl = TextEditingController();

  int _nameLen = 0;
  int _descLen = 0;
  int _accessIndex = 0; // 0 = Open, 1 = Moderated
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(() => setState(() => _nameLen = _nameCtrl.text.length));
    _descCtrl.addListener(() => setState(() => _descLen = _descCtrl.text.length));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _questionCtrl.dispose();
    super.dispose();
  }

  bool get _canCreate => _nameCtrl.text.trim().isNotEmpty;

  void _onCreate() async {
    if (!_canCreate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a channel name'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    // Build the new channel model
    final newChannel = ChannelModel(
      emoji: '📢',
      name: _nameCtrl.text.trim(),
      subtitle: _accessIndex == 0 ? 'Public' : 'Moderated',
      isFav: false,
    );

    // Fire callback BEFORE popping so parent state updates
    widget.onChannelCreated(newChannel);

    setState(() => _isCreating = false);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ "${newChannel.name}" channel created!'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPage,
      appBar: AppBar(
        backgroundColor: context.bgPage,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.txtMain, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create a channel',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.txtMain)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                // ── Headline ─────────────────────────────────────────────
                Text('Introduce your channel',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: context.txtMain,
                        height: 1.2)),
                const SizedBox(height: 28),


                // ── Channel name ──────────────────────────────────────────
                Text('Channel name',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.txtSub)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nameCtrl,
                  hint: 'Enter channel name',
                  maxLines: 1,
                  maxLength: 30,
                  context: context,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('$_nameLen/30',
                        style: TextStyle(
                            fontSize: 12, color: context.txtLight)),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Description ───────────────────────────────────────────
                Text('Channel Description (optional)',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.txtSub)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _descCtrl,
                  hint: 'What is your channel about?',
                  maxLines: 5,
                  maxLength: 200,
                  context: context,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('$_descLen/200',
                        style: TextStyle(
                            fontSize: 12, color: context.txtLight)),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Access Options ────────────────────────────────────────
                Text('Access Options',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.txtMain)),
                const SizedBox(height: 14),

                _AccessTile(
                  title: 'Open Access',
                  subtitle: 'Anyone can follow the channel without permission.',
                  selected: _accessIndex == 0,
                  onTap: () => setState(() => _accessIndex = 0),
                ),
                const SizedBox(height: 12),
                _AccessTile(
                  title: 'Moderated Access',
                  subtitle:
                      "Moderator's permission is required to follow, read and write.",
                  selected: _accessIndex == 1,
                  onTap: () => setState(() => _accessIndex = 1),
                  questionCtrl:
                      _accessIndex == 1 ? _questionCtrl : null,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── Create button ───────────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: GestureDetector(
                onTap: _isCreating ? null : _onCreate,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _canCreate
                        ? AppTheme.primary
                        : AppTheme.primary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _canCreate
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: _isCreating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
    required int maxLength,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.border),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(fontSize: 15, color: context.txtMain),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 15, color: context.txtLight),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: maxLines > 1 ? 14 : 12,
          ),
          counterText: '',
        ),
      ),
    );
  }
}

// ── Access tile ───────────────────────────────────────────────────────────────
class _AccessTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final TextEditingController? questionCtrl;

  const _AccessTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.questionCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.primary : context.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22, height: 22,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppTheme.primary : context.border,
                      width: 2,
                    ),
                    color: Colors.transparent,
                  ),
                  child: selected
                      ? Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: context.txtMain)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 13,
                              color: context.txtSub,
                              height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
            // Question field for moderated
            if (questionCtrl != null) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: context.bgPage,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.border),
                ),
                child: TextField(
                  controller: questionCtrl,
                  style: TextStyle(fontSize: 13, color: context.txtMain),
                  decoration: InputDecoration(
                    hintText: 'Add a question for people to answer...',
                    hintStyle:
                        TextStyle(fontSize: 13, color: context.txtLight),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}