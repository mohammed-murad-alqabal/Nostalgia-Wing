import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/data/app_database.dart';
import '../../../core/services/db_service.dart';
import '../../../core/di/service_locator.dart';

/// A screen to view and interact with spontaneous surprises and
/// growth suggestions.
class AddMemoryScreen extends StatefulWidget {
  /// Creates an [AddMemoryScreen].
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _saveMemory() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صورة للذكرى')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dbService = Provider.of<DBService>(context, listen: false);
      final key = await sl.keyManager.getMasterKey();

      // 1. Encrypt Content
      final encryptedTitle =
          await sl.securityService.encrypt(_titleController.text, key);
      final encryptedDesc =
          await sl.securityService.encrypt(_descriptionController.text, key);

      // 2. Encrypt & Save Image
      final imageBytes = await _imageFile!.readAsBytes();
      final encryptedBytes =
          await sl.securityService.encryptBytes(imageBytes, key);

      final appDir = await getApplicationDocumentsDirectory();
      final secureMediaDir = Directory(p.join(appDir.path, 'secure_media'));
      // ignore: avoid_slow_async_io
      // ignore: avoid_slow_async_io
      if (!await secureMediaDir.exists()) {
        await secureMediaDir.create(recursive: true);
      }

      final fileName = '${const Uuid().v4()}.enc';
      final filePath = p.join(secureMediaDir.path, fileName);
      await File(filePath).writeAsBytes(encryptedBytes);

      // 3. Save to DB
      await dbService.insertMemory(MemoriesCompanion.insert(
        title: encryptedTitle,
        encryptedContent: encryptedDesc,
        mediaPath: drift.Value(filePath),
        createdAt: drift.Value(DateTime.now()),
      ));

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل حفظ الذكرى: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('إضافة ذكرى جديدة',
              style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Picker Area
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  color: Colors.white54, size: 48),
                              SizedBox(height: 8),
                              Text('اضغط لإضافة صورة',
                                  style: TextStyle(color: Colors.white54)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                // Title Field
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('عنوان الذكرى'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'يرجى إدخال عنوان' : null,
                ),
                const SizedBox(height: 16),
                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('اكتب ما تشعر به...'),
                  maxLines: 4,
                ),
                const SizedBox(height: 32),
                // Save Button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveMemory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('حفظ في جناح الحنين',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF43F5E)),
        ),
      );
}
