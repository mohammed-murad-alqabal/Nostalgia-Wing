import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
    _suggestedMessage =
        await _emotionalMessageService.getSuggestedResonantMessage();
    // _allTemplates loaded within service if needed for history
    setState(() {});
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);
    _history = await _emotionalMessageService.getDecryptedHistory();
    setState(() => _isLoadingHistory = false);
  }

  /// Handles sending a message.
  Future<void> _handleSendMessage(String content, String type) async {
    SensoryFeedbackService.selectionClick();

    // Save to encrypted history
    await _emotionalMessageService.saveSentMessage(
      content: content,
      type: type,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال الرسالة وحفظها في السجل بنجاح! ❤️'),
          backgroundColor: Colors.pink,
        ),
      );
      _loadHistory(); // Refresh history
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
                    onPressed: () => _handleSendMessage(
                        _suggestedMessage!.content, _suggestedMessage!.type),
                    icon: const Icon(Icons.send, size: 16),
                    label: const Text('إرسال'),
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
              onPressed: _customMessage.isEmpty
                  ? null
                  : () => _handleSendMessage(_customMessage, 'custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('إرسال وحفظ'),
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
