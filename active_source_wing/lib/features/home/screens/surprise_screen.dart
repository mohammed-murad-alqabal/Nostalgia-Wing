import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/services/db_service.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/services/sensory_feedback_service.dart';

/// A screen to view and interact with spontaneous surprises and
/// growth suggestions.
class SurpriseScreen extends StatefulWidget {
  /// Creates a [SurpriseScreen].
  const SurpriseScreen({super.key, required this.onClose});

  /// Callback function to close the screen.
  final VoidCallback onClose;

  @override
  State<SurpriseScreen> createState() => _SurpriseScreenState();
}

class _SurpriseScreenState extends State<SurpriseScreen> {
  late DBService _dbService;

  bool _isLoading = true;
  List<Map<String, dynamic>> _surprises = [];

  @override
  void initState() {
    super.initState();
    _dbService = Provider.of<DBService>(context, listen: false);
    _loadSurprises();
  }

  Future<void> _loadSurprises() async {
    setState(() => _isLoading = true);
    final rawSurprises = await _dbService.getSurprises();
    final decodedList = <Map<String, dynamic>>[];
    for (final s in rawSurprises) {
      try {
        final content = await sl.encryptionService.decrypt(s.encryptedContent);
        decodedList.add({
          'id': s.id,
          'type': s.type,
          'content': content,
          'status': s.status,
          'createdAt': s.createdAt,
        });
      } catch (e) {
        // Skip un-decryptable content
      }
    }

    setState(() {
      _surprises = decodedList.reversed.toList(); // Newest first
      _isLoading = false;
    });
  }

  Future<void> _handleAction(int id, String newStatus) async {
    SensoryFeedbackService.selectionClick();
    await _dbService.updateSurpriseStatus(id, newStatus);
    _loadSurprises();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const Divider(),
                Flexible(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _surprises.isEmpty
                          ? _buildEmptyState()
                          : _buildSurpriseList(),
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
              const Icon(Icons.auto_awesome, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                'مفاجآت جناح الحنين',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[800],
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

  Widget _buildEmptyState() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.hourglass_empty, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد مفاجآت حالياً. انتظر قليلاً، الفوضى الهادفة قادمة!'),
          ],
        ),
      );

  Widget _buildSurpriseList() => ListView.builder(
        shrinkWrap: true,
        itemCount: _surprises.length,
        itemBuilder: (context, index) {
          final s = _surprises[index];
          final dateStr = DateFormat('yyyy/MM/dd HH:mm').format(s['createdAt']);
          final isPending = s['status'] == 'pending';

          return Card(
            elevation: isPending ? 4 : 0,
            color: isPending ? Colors.deepPurple[50] : Colors.grey[100],
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getTypeBadge(s['type']),
                      Text(dateStr,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s['content'],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      color: isPending ? Colors.black87 : Colors.black45,
                      fontWeight:
                          isPending ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'هذه اللحظة تعكس عمق المودة بينكما.'
                    ' تذكروا دائماً قوله تعالى: '
                    '"وجعل بينكم مودة ورحمة".',
                    style: TextStyle(
                        color: Colors.white60, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.right,
                  ),
                  if (isPending) ...[
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _handleAction(s['id'], 'dismissed'),
                          child: const Text('تجاهل',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _handleAction(s['id'], 'completed'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('تم'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );

  Widget _getTypeBadge(String type) {
    String label = 'مفاجأة';
    Color color = Colors.deepPurple;
    if (type == 'growth') {
      label = 'فرصة نمو';
      color = Colors.green;
    } else if (type == 'transformation') {
      label = 'تحول صغير';
      color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
