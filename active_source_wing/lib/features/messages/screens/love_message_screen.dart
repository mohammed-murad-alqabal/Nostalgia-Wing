import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/models/message_template.dart';
import '../../../core/services/emotional_message_service.dart';
import '../../../core/services/sensory_feedback_service.dart';

/// A screen for sending and managing love messages.
class LoveMessageScreen extends StatefulWidget {
  /// Creates a [LoveMessageScreen].
  const LoveMessageScreen({super.key, required this.onClose});

  /// Callback function to close the screen.
  final VoidCallback onClose;

  @override
  State<LoveMessageScreen> createState() => _LoveMessageScreenState();
}

class _LoveMessageScreenState extends State<LoveMessageScreen>
    with SingleTickerProviderStateMixin {
  late EmotionalMessageService _emotionalMessageService;
  late TabController _tabController;

  MessageTemplate? _suggestedMessage;
  String _customMessage = '';
  List<Map<String, dynamic>> _history = [];
  bool _isLoadingHistory = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _emotionalMessageService =
        Provider.of<EmotionalMessageService>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    _loadMessages();
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final suggested =
        await _emotionalMessageService.getSuggestedResonantMessage();
    if (!mounted) return;
    setState(() => _suggestedMessage = suggested);
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    setState(() => _isLoadingHistory = true);
    try {
      final history = await _emotionalMessageService.getDecryptedHistory();
      if (!mounted) return;
      setState(() => _history = history);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحميل سجل الرسائل حالياً.')),
      );
    } finally {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  /// Handles sending a message.
  Future<void> _handleSendMessage(String content, String type) async {
    if (_isSaving || content.trim().isEmpty) return;
    SensoryFeedbackService.selectionClick();
    setState(() => _isSaving = true);

    try {
      await _emotionalMessageService.saveSentMessage(
        content: content.trim(),
        type: type,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الرسالة في السجل المشفر.'),
          backgroundColor: Colors.pink,
        ),
      );
      await _loadHistory();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر حفظ الرسالة حالياً.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _shareMessage(String message) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          subject: 'رسالة من جناح الحنين',
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذرت مشاركة الرسالة من الجهاز.')),
      );
    }
  }

  /// Handles copying a message to the clipboard.
  void _handleCopyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    SensoryFeedbackService.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الرسالة!')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                _buildTabBar(),
                const SizedBox(height: 20),
                Flexible(
                  child: SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildComposerTab(),
                        _buildHistoryTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pink),
              const SizedBox(width: 8),
              Text(
                'رسائل الحب',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
          ),
        ],
      );

  Widget _buildTabBar() => TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'إرسال'),
          Tab(text: 'السجل'),
        ],
        labelColor: Colors.pink,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.pink,
      );

  Widget _buildComposerTab() => SingleChildScrollView(
        child: Column(
          children: [
            if (_suggestedMessage != null) _buildSuggestedCard(),
            const SizedBox(height: 20),
            _buildCustomComposer(),
          ],
        ),
      );

  Widget _buildSuggestedCard() => Card(
        color: Colors.amber[50],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.amber[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('✨ مقترح الآن',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(_suggestedMessage!.type,
                      style: const TextStyle(fontSize: 10)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _suggestedMessage!.content,
                textAlign: TextAlign.right,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _handleSendMessage(_suggestedMessage!.content,
                            _suggestedMessage!.type),
                    icon: const Icon(Icons.save_alt, size: 16),
                    label: const Text('حفظ في السجل'),
                  ),
                  TextButton.icon(
                    onPressed: () => _shareMessage(_suggestedMessage!.content),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('مشاركة'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildCustomComposer() => Column(
        children: [
          TextField(
            maxLines: 4,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'اكتب ما في قلبك...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (v) => setState(() => _customMessage = v),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving || _customMessage.trim().isEmpty
                  ? null
                  : () => _handleSendMessage(_customMessage, 'custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('حفظ في السجل'),
            ),
          ),
        ],
      );

  Widget _buildHistoryTab() {
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_history.isEmpty) {
      return const Center(child: Text('لا يوجد سجل رسائل بعد'));
    }
    return ListView.builder(
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final entry = _history[index];
        final dateStr = DateFormat('yyyy/MM/dd HH:mm').format(entry['sentAt']);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(entry['content'], textAlign: TextAlign.right),
            subtitle: Text(dateStr, style: const TextStyle(fontSize: 10)),
            leading:
                Icon(_getMessageIcon(entry['type']), color: Colors.pink[300]),
            trailing: IconButton(
              tooltip: 'مشاركة',
              icon: const Icon(Icons.share, color: Colors.pink),
              onPressed: () => _shareMessage(entry['content']),
            ),
            onTap: () => _handleCopyMessage(entry['content']),
          ),
        );
      },
    );
  }

  IconData _getMessageIcon(String type) {
    if (type == 'morning') return Icons.wb_sunny;
    if (type == 'evening') return Icons.nights_stay;
    return Icons.favorite_border;
  }
}
