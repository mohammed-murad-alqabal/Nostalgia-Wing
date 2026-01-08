import 'package:flutter/material.dart';
import '../../../core/infrastructure/wing_logger.dart';

/// Screen for application settings and preferences.
class SettingsScreen extends StatelessWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

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
                'تغيير اسمك في التطبيق',
                () {},
              ),
              _buildSettingsTile(
                Icons.favorite_outline,
                'شريك الحياة',
                'إدارة ملف الشريك',
                () {},
              ),
            ]),
            const SizedBox(height: 25),
            _buildSettingsGroup('التجربة البصرية', [
              _buildSettingsTile(
                Icons.palette_outlined,
                'سمة التطبيق',
                'تخصيص الألوان والمظهر',
                () {},
              ),
              _buildSettingsTile(
                Icons.animation,
                'الحركات والمؤثرات',
                'تحسين الأداء البصري',
                () {},
              ),
            ]),
            const SizedBox(height: 25),
            _buildSettingsGroup('الأمان والخصوصية', [
              _buildSettingsTile(
                Icons.lock_outline,
                'قفل التطبيق',
                'حماية ذكرياتك برمز سري',
                () {},
              ),
              _buildSettingsTile(
                Icons.security,
                'تشفير البيانات',
                'إدارة مفاتيح التشفير المحلية',
                () {},
              ),
            ]),
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () {
                  WingLogger.info('تسجيل الخروج', tag: 'Settings');
                },
                child: const Text(
                  'تسجيل الخروج من الكيان',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'جناح الحنين v2.1.0',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3), fontSize: 12),
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
            child: Column(
              children: children,
            ),
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
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
        ),
        trailing:
            const Icon(Icons.chevron_left, color: Color(0xFF94A3B8), size: 20),
      );
}
