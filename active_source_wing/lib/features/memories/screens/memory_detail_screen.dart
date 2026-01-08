import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/data/app_database.dart';
import '../../../core/services/db_service.dart';
import '../../../core/di/service_locator.dart';

/// Screen for displaying details of a memory.
class MemoryDetailScreen extends StatefulWidget {
  /// Creates a [MemoryDetailScreen].
  const MemoryDetailScreen(
      {super.key, required this.memory, required this.onClose});

  /// The memory to display.
  final Memory memory;

  /// Callback when close is requested.
  final VoidCallback onClose;

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  late Memory _currentMemory;
  String _decryptedTitle = '';
  String _decryptedDescription = '';
  Uint8List? _decryptedImageBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentMemory = widget.memory;
    _decryptContent();
  }

  Future<void> _decryptContent() async {
    try {
      final key = await sl.keyManager.getMasterKey();

      // Decrypt Title (In our new implementation, title is encrypted in the DB)
      final decryptedTitle =
          await sl.securityService.decrypt(_currentMemory.title, key);

      // Decrypt Description
      final decryptedDesc = await sl.securityService
          .decrypt(_currentMemory.encryptedContent, key);

      // Decrypt Image if exists
      Uint8List? imageBytes;
      if (_currentMemory.mediaPath != null) {
        final encryptedBytes =
            await File(_currentMemory.mediaPath!).readAsBytes();
        imageBytes = await sl.securityService.decryptBytes(encryptedBytes, key);
      }

      if (mounted) {
        setState(() {
          _decryptedTitle = decryptedTitle;
          _decryptedDescription = decryptedDesc;
          _decryptedImageBytes = imageBytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _decryptedTitle = 'خطأ في التشفير';
          _decryptedDescription = 'لا يمكن عرض المحتوى: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteMemory() async {
    final dbService = Provider.of<DBService>(context, listen: false);
    await dbService.deleteMemory(_currentMemory.id);
    if (_currentMemory.mediaPath != null) {
      final file = File(_currentMemory.mediaPath!);
      // ignore: avoid_slow_async_io
      if (await file.exists()) {
        await file.delete();
      }
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: widget.onClose,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1E293B),
                    title: const Text('حذف الذكرى',
                        style: TextStyle(color: Colors.white)),
                    content: const Text(
                        'هل أنت متأكد من حذف هذه الذكرى الجميلة؟',
                        style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تراجع')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteMemory();
                          },
                          child: const Text('حذف',
                              style: TextStyle(color: Colors.redAccent))),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Display
                    if (_decryptedImageBytes != null)
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(_decryptedImageBytes!,
                              fit: BoxFit.cover),
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      _decryptedTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    // Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.white54, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMMM yyyy - HH:mm', 'ar')
                              .format(_currentMemory.createdAt),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Divider
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 24),
                    // Description
                    Text(
                      _decryptedDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 48),
                    // Spiritual Insight Placeholder (رفيق الروح)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color:
                                const Color(0xFFF43F5E).withValues(alpha: 0.3)),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('رفيق الروح',
                                  style: TextStyle(
                                      color: Color(0xFFF43F5E),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.auto_awesome,
                                  color: Color(0xFFF43F5E), size: 20),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'هذه اللحظة تعكس عمق المودة بينكما.'
                            ' تذكروا دائماً قوله تعالى: '
                            '"وجعل بينكم مودة ورحمة".',
                            style: TextStyle(
                                color: Colors.white60,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );
}
