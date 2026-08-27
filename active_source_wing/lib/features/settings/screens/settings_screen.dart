import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/performance/performance_adaptation_service.dart';
import '../../../core/performance/performance_monitor.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/settings_service.dart';

/// شاشة الإعدادات الفعلية للتفضيلات المحلية والجلسة.
class SettingsScreen extends StatefulWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsService _settings;
  late final PerformanceAdaptationService _performance;

  @override
  void initState() {
    super.initState();
    _settings = sl.settingsService;
    _performance = PerformanceAdaptationService();
  }

  Future<void> _editTextSetting({
    required String title,
    required String label,
    required String initialValue,
    required Future<void> Function(String value) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 80,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (value == null || value.trim().isEmpty) return;
    await onSave(value);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الإعداد بنجاح.')),
    );
  }

  Future<void> _choosePerformance() async {
    final selected = await showDialog<PerformanceLevel?>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('الحركات والمؤثرات'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('تلقائي حسب أداء الجهاز'),
          ),
          for (final level in PerformanceLevel.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, level),
              child: Text(_performanceLabel(level)),
            ),
        ],
      ),
    );
    if (!mounted) return;
    await _performance.setOverride(selected);
    if (!mounted) return;
    setState(() {});
  }

  String _performanceLabel(PerformanceLevel level) {
    switch (level) {
      case PerformanceLevel.high:
        return 'أداء عالٍ — مؤثرات كاملة';
      case PerformanceLevel.medium:
        return 'متوازن — مؤثرات مخففة';
      case PerformanceLevel.low:
        return 'توفير الطاقة — مؤثرات أساسية';
    }
  }

  void _showInfoDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message, textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text(
            'سيتم إغلاق الجلسة المحلية ومنع الوصول للبيانات حتى إعادة التحقق.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await context.read<AuthService>().logout();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'الإعدادات',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSettingsGroup('الملف الشخصي', [
              _buildSettingsTile(
                Icons.person_outline,
                'الاسم المعرفي',
                _settings.displayName.isEmpty
                    ? 'لم يُحدد بعد'
                    : _settings.displayName,
                () => _editTextSetting(
                  title: 'الاسم المعرفي',
                  label: 'الاسم',
                  initialValue: _settings.displayName,
                  onSave: _settings.setDisplayName,
                ),
              ),
              _buildSettingsTile(
                Icons.favorite_outline,
                'شريك الحياة',
                _settings.partnerName.isEmpty
                    ? 'لم يُحدد بعد'
                    : _settings.partnerName,
                () => _editTextSetting(
                  title: 'شريك الحياة',
                  label: 'الاسم',
                  initialValue: _settings.partnerName,
                  onSave: _settings.setPartnerName,
                ),
              ),
            ]),
            const SizedBox(height: 25),
            _buildSettingsGroup('التجربة البصرية', [
              _buildSettingsTile(
                Icons.palette_outlined,
                'سمة التطبيق',
                'السمة الحالية متكيفة مع الحالة العاطفية',
                () => _showInfoDialog(
                  'السمة المتكيفة',
                  'يستخدم التطبيق حالياً سمة متكيفة مع الحالة '
                      'العاطفية المسجلة. لا يوجد تخصيص يدوي مستقل في '
                      'هذه النسخة.',
                ),
              ),
              _buildSettingsTile(
                Icons.animation,
                'الحركات والمؤثرات',
                _performance.useDynamic
                    ? 'تلقائي حسب أداء الجهاز'
                    : _performanceLabel(_performance.overrideLevel!),
                _choosePerformance,
              ),
            ]),
            const SizedBox(height: 25),
            _buildSettingsGroup('الأمان والخصوصية', [
              _buildSettingsTile(
                Icons.lock_outline,
                'قفل التطبيق',
                'الجلسة المحلية الحالية؛ القفل برمز غير مفعل '
                    'بعد',
                () => _showInfoDialog(
                  'قفل التطبيق',
                  'يعتمد التطبيق حالياً على جلسة محلية داخل الذاكرة. '
                      'قفل الجهاز أو PIN مستقل يحتاج تفعيله قبل اعتباره '
                      'حماية إضافية.',
                ),
              ),
              _buildSettingsTile(
                Icons.security,
                'تشفير البيانات',
                'البيانات المحلية الحساسة مشفرة قبل التخزين',
                () => _showInfoDialog(
                  'تشفير البيانات',
                  'يستخدم التطبيق خدمة التشفير الإصدارية للبيانات المحلية '
                      'والوسائط. لا يعني ذلك وجود مزامنة أو تشفير طرفي بين '
                      'أجهزة.',
                ),
              ),
            ]),
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: _logout,
                child: const Text(
                  'تسجيل الخروج من الجلسة المحلية',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'جناح الحنين v2.2.0',
                style: TextStyle(color: Colors.white30, fontSize: 12),
              ),
            ),
          ],
        ),
      );

  Widget _buildSettingsGroup(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(children: children),
          ),
        ],
      );

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) =>
      ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
        ),
        trailing:
            const Icon(Icons.chevron_left, color: Color(0xFF94A3B8), size: 20),
      );
}
