import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/data/app_database.dart';
import '../../../core/services/db_service.dart';
import '../../../core/di/service_locator.dart';
import 'memory_detail_screen.dart';
import 'add_memory_screen.dart';

/// Screen for displaying a list of all memories.
class MemoriesListScreen extends StatefulWidget {
  /// Creates a [MemoriesListScreen].
  const MemoriesListScreen({super.key});

  @override
  State<MemoriesListScreen> createState() => _MemoriesListScreenState();
}

class _MemoriesListScreenState extends State<MemoriesListScreen> {
  List<Memory> _memories = [];
  final Map<int, String> _decryptedTitles = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final dbService = Provider.of<DBService>(context, listen: false);
    final memories = await dbService.getMemories();

    try {
      // Decrypt titles for display only. Keep the original encrypted rows so
      // MemoryDetailScreen can decrypt them exactly once.
      final decryptedTitles = <int, String>{};
      for (final memory in memories) {
        try {
          decryptedTitles[memory.id] =
              await sl.encryptionService.decrypt(memory.title);
        } catch (_) {
          decryptedTitles[memory.id] = 'تعذر قراءة عنوان الذكرى';
        }
      }

      if (mounted) {
        setState(() {
          _memories = memories
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          _decryptedTitles
            ..clear()
            ..addAll(decryptedTitles);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _memories = memories
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          _decryptedTitles
            ..clear()
            ..addEntries(memories.map(
                (memory) => MapEntry(memory.id, 'تعذر قراءة عنوان الذكرى')));
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'الذكريات',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddMemoryScreen()),
                );
                if (result == true) {
                  _loadMemories();
                }
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _memories.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _memories.length,
                    itemBuilder: (context, index) {
                      final memory = _memories[index];
                      return _buildMemoryCard(memory);
                    },
                  ),
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined,
                size: 80, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            const Text(
              'لا توجد ذكريات بعد',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بتوثيق لحظاتك الجميلة',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
      );

  Widget _buildMemoryCard(Memory memory) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemoryDetailScreen(
                  memory: memory,
                  onClose: () => Navigator.pop(context),
                ),
              ),
            );
            _loadMemories();
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.pink),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _decryptedTitles[memory.id] ??
                            'تعذر قراءة عنوان الذكرى',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMMM yyyy', 'ar')
                            .format(memory.createdAt),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      );
}
