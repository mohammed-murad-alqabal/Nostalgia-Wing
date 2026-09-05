import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/app_database.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/infrastructure/app_storage_directory.dart';
import '../../../core/services/db_service.dart';

/// شاشة إنشاء ذكرى أو تعديل ذكرى محفوظة.
class AddMemoryScreen extends StatefulWidget {
  /// Creates an [AddMemoryScreen].
  const AddMemoryScreen({super.key, this.memory});

  /// Existing memory when the screen is used as an editor.
  final Memory? memory;

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  Uint8List? _existingImageBytes;
  bool _isSaving = false;
  bool _isLoadingExisting = false;

  bool get _isEditing => widget.memory != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _loadExistingMemory();
  }

  Future<void> _loadExistingMemory() async {
    final memory = widget.memory!;
    setState(() => _isLoadingExisting = true);
    try {
      final title = await sl.encryptionService.decrypt(memory.title);
      final description =
          await sl.encryptionService.decrypt(memory.encryptedContent);
      Uint8List? imageBytes;
      if (memory.mediaPath != null) {
        final encryptedBytes = File(memory.mediaPath!).readAsBytesSync();
        imageBytes = await sl.encryptionService.decryptBytes(encryptedBytes);
      }
      if (!mounted) return;
      _titleController.text = title;
      _descriptionController.text = description;
      setState(() {
        _existingImageBytes = imageBytes;
        _isLoadingExisting = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingExisting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحميل الذكرى للتحرير.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() {
        _imageFile = File(image.path);
        _existingImageBytes = null;
      });
    }
  }

  Future<void> _saveMemory() async {
    if (_isLoadingExisting || !_formKey.currentState!.validate()) return;
    if (!_isEditing && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صورة للذكرى')),
      );
      return;
    }

    setState(() => _isSaving = true);
    String? savedFilePath;

    try {
      final dbService = Provider.of<DBService>(context, listen: false);
      final encryptedTitle =
          await sl.encryptionService.encrypt(_titleController.text.trim());
      final encryptedDescription = await sl.encryptionService
          .encrypt(_descriptionController.text.trim());

      String? mediaPath;
      if (_imageFile != null) {
        final imageBytes = await _imageFile!.readAsBytes();
        final encryptedBytes =
            await sl.encryptionService.encryptBytes(imageBytes);
        final appDir = await resolveAppDocumentsDirectory();
        final secureMediaDir = Directory(p.join(appDir.path, 'secure_media'));
        if (!secureMediaDir.existsSync()) {
          await secureMediaDir.create(recursive: true);
        }

        final fileName = '${const Uuid().v4()}.enc';
        mediaPath = p.join(secureMediaDir.path, fileName);
        savedFilePath = mediaPath;
        await File(mediaPath).writeAsBytes(encryptedBytes);
      }

      if (_isEditing) {
        final existing = widget.memory!;
        final updated = mediaPath == null
            ? existing.copyWith(
                title: encryptedTitle,
                encryptedContent: encryptedDescription,
              )
            : existing.copyWith(
                title: encryptedTitle,
                encryptedContent: encryptedDescription,
                mediaPath: drift.Value(mediaPath),
              );
        await dbService.saveMemory(updated);
      } else {
        await dbService.insertMemory(
          MemoriesCompanion.insert(
            title: encryptedTitle,
            encryptedContent: encryptedDescription,
            mediaPath: drift.Value(mediaPath),
            createdAt: drift.Value(DateTime.now()),
          ),
        );
      }

      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (savedFilePath != null) {
        try {
          final partialFile = File(savedFilePath);
          if (partialFile.existsSync()) partialFile.deleteSync();
        } catch (_) {
          // Cleanup is best effort; the user still receives a safe error.
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('تعذر حفظ الذكرى حالياً. حاول مرة أخرى.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            _isEditing ? 'تعديل الذكرى' : 'إضافة ذكرى جديدة',
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isLoadingExisting
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                  child: Image.file(_imageFile!,
                                      fit: BoxFit.cover),
                                )
                              : _existingImageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.memory(
                                        _existingImageBytes!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate_outlined,
                                            color: Colors.white54, size: 48),
                                        SizedBox(height: 8),
                                        Text('اضغط لإضافة صورة',
                                            style: TextStyle(
                                                color: Colors.white54)),
                                      ],
                                    ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('عنوان الذكرى'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'يرجى إدخال عنوان'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('اكتب ما تشعر به...'),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 32),
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
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                _isEditing
                                    ? 'حفظ التعديلات'
                                    : 'حفظ في جناح الحنين',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
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
