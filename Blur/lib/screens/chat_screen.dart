import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ChatMessage {
  final String id;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isOwn;
  final String? senderInitials;
  final Color? senderColor;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isOwn,
    this.senderInitials,
    this.senderColor,
  });
}

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userInitials;
  const ChatScreen({
    super.key,
    required this.userName,
    required this.userInitials,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  
  bool _canSend = false;
  List<ChatMessage> messages = [
    ChatMessage(
      id: '1',
      senderName: 'User 1',
      message: 'Hey! How are you doing?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isOwn: false,
      senderInitials: 'U1',
      senderColor: const Color(0xFF3B5BDB),
    ),
    ChatMessage(
      id: '2',
      senderName: 'You',
      message: 'Hi! I\'m doing great, thanks for asking!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      isOwn: true,
      senderInitials: 'YO',
    ),
    ChatMessage(
      id: '3',
      senderName: 'User 1',
      message: 'Did you get a chance to check the study materials?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isOwn: false,
      senderInitials: 'U1',
      senderColor: const Color(0xFF3B5BDB),
    ),
    ChatMessage(
      id: '4',
      senderName: 'You',
      message: 'Yes! They were really helpful. Thanks for sharing!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isOwn: true,
      senderInitials: 'YO',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageCtrl.addListener(_updateSendButton);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _updateSendButton() {
    final text = _messageCtrl.text.trim();
    setState(() {
      _canSend = text.isNotEmpty && !_isInvalidMessage(text);
    });
  }

  bool _isInvalidMessage(String text) {
    // Check if message is only numbers
    final numericOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericOnly == text && text.isNotEmpty) {
      return true; // Only numbers - invalid
    }
    return false;
  }

  void _showMessageError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageCtrl.text.trim();

    // Validate message
    if (text.isEmpty) {
      _showMessageError('Message cannot be empty');
      return;
    }

    if (_isInvalidMessage(text)) {
      _showMessageError('Messages cannot contain only numbers');
      return;
    }

    // Add message to list
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: 'You',
      message: text,
      timestamp: DateTime.now(),
      isOwn: true,
      senderInitials: widget.userInitials,
    );

    setState(() {
      messages.add(newMessage);
    });

    _messageCtrl.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // ignore: unused_element
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.bgCard,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              decoration: BoxDecoration(
                color: context.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Chat Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.txtMain,
                ),
              ),
            ),
            const Divider(height: 1),
            _ChatOptionTile(
              icon: Icons.block,
              label: 'Block User',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation();
              },
            ),
            _ChatOptionTile(
              icon: Icons.flag_outlined,
              label: 'Report User',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                _showReportDialog();
              },
            ),
            _ChatOptionTile(
              icon: Icons.clear_all,
              label: 'Clear Chat',
              color: Colors.amber,
              onTap: () {
                Navigator.pop(context);
                _showClearChatConfirmation();
              },
            ),
            _ChatOptionTile(
              icon: Icons.info_outline,
              label: 'Chat Info',
              color: AppTheme.primary,
              onTap: () {
                Navigator.pop(context);
                _showChatInfo();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.bgCard,
        title: Text(
          'Block ${widget.userName}?',
          style: TextStyle(color: context.txtMain, fontSize: 16),
        ),
        content: Text(
          'You won\'t see messages from this user anymore.',
          style: TextStyle(color: context.txtSub),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.userName} has been blocked'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.bgCard,
        title: Text(
          'Report ${widget.userName}?',
          style: TextStyle(color: context.txtMain, fontSize: 16),
        ),
        content: Text(
          'Your report will be reviewed by our moderation team.',
          style: TextStyle(color: context.txtSub),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showClearChatConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.bgCard,
        title: Text(
          'Clear all messages?',
          style: TextStyle(color: context.txtMain, fontSize: 16),
        ),
        content: Text(
          'This action cannot be undone.',
          style: TextStyle(color: context.txtSub),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => messages.clear());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat cleared'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.bgCard,
        title: Text(
          'Chat Info',
          style: TextStyle(color: context.txtMain),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: ${widget.userName}',
              style: TextStyle(color: context.txtSub),
            ),
            const SizedBox(height: 8),
            Text(
              'Messages: ${messages.length}',
              style: TextStyle(color: context.txtSub),
            ),
            const SizedBox(height: 8),
            Text(
              'Encrypted: End-to-End',
              style: TextStyle(color: context.txtSub),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.txtMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: context.txtMain,
              ),
            ),
            Text(
              'Encrypted',
              style: TextStyle(
                fontSize: 11,
                color: context.txtLight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call_outlined, color: context.txtMain),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice call not available'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: context.txtMain),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: context.txtLight,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.txtSub,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.txtLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (_, i) => _MessageBubble(
                      message: messages[i],
                      context: context,
                    ),
                  ),
          ),

          // Message Input
          Container(
            color: context.bgSurface,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // Info Button
                Tooltip(
                  message: 'Pictures are not allowed in chats\nOnly text messages',
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: context.txtLight,
                      size: 20,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '📝 Text-only messages\n❌ No pictures or attachments\n❌ No numeric-only messages',
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ),

                // Message Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.bgCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: context.border, width: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _messageCtrl,
                      maxLines: null,
                      minLines: 1,
                      maxLength: 500,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.txtMain,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: context.txtLight,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                // Send Button
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _canSend ? _sendMessage : null,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _canSend
                          ? AppTheme.primary
                          : AppTheme.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message Bubble ────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final BuildContext context;

  const _MessageBubble({
    required this.message,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isOwn) ...[
            AnonAvatar(
              size: 32,
              initials: message.senderInitials ?? 'U',
              bg: message.senderColor,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isOwn
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!message.isOwn)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: message.isOwn
                        ? AppTheme.primary
                        : context.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: !message.isOwn
                        ? Border.all(
                            color: context.border,
                            width: 0.5,
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: message.isOwn
                          ? Colors.white
                          : context.txtMain,
                      height: 1.4,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: context.txtLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (message.isOwn) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

// ── Chat Option Tile ──────────────────────────────────────────────────────────
class _ChatOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ChatOptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}