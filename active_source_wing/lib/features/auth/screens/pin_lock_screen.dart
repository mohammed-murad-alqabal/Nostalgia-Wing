import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';

/// شاشة فتح الجلسة المحلية عند تفعيل PIN.
class PinLockScreen extends StatefulWidget {
  /// Creates a [PinLockScreen].
  const PinLockScreen({super.key, required this.onUnlocked});

  /// Called after the local PIN is verified.
  final VoidCallback onUnlocked;

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final _pinController = TextEditingController();
  bool _isChecking = false;
  String? _errorMessage;

  Future<void> _unlock() async {
    if (_isChecking || _pinController.text.isEmpty) return;
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    final success = await AuthService.instance.authenticateWithPin(
      _pinController.text,
    );
    if (!mounted) return;

    if (success) {
      widget.onUnlocked();
    } else {
      setState(() {
        _isChecking = false;
        _errorMessage = 'الرمز غير صحيح. حاول مرة أخرى.';
        _pinController.clear();
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline,
                        color: Color(0xFFF43F5E), size: 72),
                    const SizedBox(height: 20),
                    const Text(
                      'الجلسة مقفلة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'أدخل رمز PIN المحلي للوصول إلى ذكرياتك.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _pinController,
                      autofocus: true,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 8,
                      style: const TextStyle(
                          color: Colors.white, letterSpacing: 8),
                      onSubmitted: (_) => _unlock(),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '••••',
                        hintStyle: const TextStyle(color: Colors.white30),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        errorText: _errorMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isChecking ? null : _unlock,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF43F5E),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: _isChecking
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('فتح التطبيق'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
