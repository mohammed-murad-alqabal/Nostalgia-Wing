import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/infrastructure/institutional_governance_manager.dart';
import '../../../../core/infrastructure/living_documentation_system.dart';
import '../../../../core/infrastructure/wing_logger.dart';
import '../../../../core/cognitive/psychological_context_manager.dart';
import '../../../../core/cognitive/relational_analytics_service.dart';
import '../../../../core/security/privacy_maintenance_service.dart';
import '../../../../core/services/sensory_feedback_service.dart';
import '../../../messages/screens/love_message_screen.dart';

/// The Intelligence Lab Screen
/// A high-tech dashboard to monitor and animate all core intelligence
/// mechanisms.
class IntelligenceLabScreen extends StatefulWidget {
  /// Creates an [IntelligenceLabScreen].
  const IntelligenceLabScreen({super.key});

  @override
  State<IntelligenceLabScreen> createState() => _IntelligenceLabScreenState();
}

class _IntelligenceLabScreenState extends State<IntelligenceLabScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WingLogger.info('تم فتح مختبر الذكاء المتقدم', tag: 'IntelligenceLab');
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F172A), // Dark cosmic blue
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildCentralBrain(),
                    const SizedBox(height: 40),
                    _buildSectionHeader('الأنظمة الحية - Core Systems'),
                    _buildEngineGrid(),
                    const SizedBox(height: 30),
                    _buildSectionHeader(
                        'الاستقرار العاطفي - Emotional Stability'),
                    _buildStabilityChart(),
                    const SizedBox(height: 30),
                    _buildSectionHeader('سرعة التفاعل - Engagement Velocity'),
                    _buildEngagementChart(),
                    const SizedBox(height: 30),
                    _buildSectionHeader('تقارير المعرفية - Governance Reports'),
                    _buildReportSection(),
                    const SizedBox(height: 30),
                    _buildPrivacyMaintenanceButton(),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSliverAppBar() => SliverAppBar(
        backgroundColor: Colors.transparent,
        expandedHeight: 120,
        floating: true,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: const Text(
            'مختبر الذكاء المعرفي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      );

  Widget _buildCentralBrain() => Center(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF38BDF8),
                    Color(0xFF0EA5E9),
                    Colors.transparent
                  ],
                  stops: [0.2, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0EA5E9).withValues(alpha: 0.5),
                    blurRadius: 25,
                    spreadRadius: 8 * (_pulseAnimation.value - 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Widget _buildSectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
      );

  Widget _buildEngineGrid() => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildEngineCard(
            'نحو الحوكمة',
            'Governance',
            Icons.gavel,
            true,
            const Color(0xFFF43F5E),
            () {
              SensoryFeedbackService.selectionClick();
              _showGovernanceReport();
            },
          ),
          _buildEngineCard(
            'التوثيق الحي',
            'Living Docs',
            Icons.auto_stories,
            true,
            const Color(0xFF10B981),
            () {
              SensoryFeedbackService.selectionClick();
              _showDocsIndex();
            },
          ),
          _buildEngineCard(
            'محرك الرنين',
            'Resonance',
            Icons.graphic_eq,
            true,
            const Color(0xFF8B5CF6),
            () {
              SensoryFeedbackService.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoveMessageScreen(
                    onClose: () => Navigator.pop(context),
                  ),
                ),
              );
            },
          ),
          _buildEngineCard(
            'الجاذبية العاطفية',
            'Gravity',
            Icons.blur_circular,
            true,
            const Color(0xFFF59E0B),
            () => _showDataDialog(
              'الجاذبية العاطفية',
              'يتم تسجيل الجاذبية عند تفاعل المستخدم مع القلب أو تسجيل '
                  'انعكاس. لا يعرض هذا المؤشر رقماً مصطنعاً قبل توفر سجل '
                  'تفاعلات.',
            ),
          ),
        ],
      );

  Widget _buildEngineCard(
    String arTitle,
    String enTitle,
    IconData icon,
    bool isActive,
    Color color,
    VoidCallback onTap,
  ) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isActive ? color.withValues(alpha: 0.5) : Colors.transparent,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? color : Colors.grey, size: 24),
              const SizedBox(height: 6),
              Text(
                arTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                enTitle,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
              ),
              const SizedBox(height: 5),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? color : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildReportSection() => Column(
        children: [
          _buildReportTile(
            'تقرير الامتثال والمعرفية',
            'Compliance Report',
            Icons.verified_user,
            const Color(0xFF38BDF8),
            () => _showGovernanceReport(),
          ),
          const SizedBox(height: 10),
          _buildReportTile(
            'فهرس التوثيق الحي',
            'Living Docs Index',
            Icons.list_alt,
            const Color(0xFF818CF8),
            () => _showDocsIndex(),
          ),
        ],
      );

  Widget _buildReportTile(String arName, String enName, IconData icon,
          Color color, VoidCallback onTap) =>
      Material(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          title: Text(arName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(enName,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
        ),
      );

  Future<RelationalReport?> _loadReport() async {
    try {
      final contextManager = context.read<PsychologicalContextManager>();
      final analytics = context.read<RelationalAnalyticsService>();
      return await analytics
          .analyzeRelationalHealth(contextManager.interactions);
    } catch (_) {
      return null;
    }
  }

  bool get _hasInteractions {
    try {
      return context
          .read<PsychologicalContextManager>()
          .interactions
          .isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Widget _buildStabilityChart() => _buildMetricCard(
        title: 'الاستقرار الحالي',
        icon: Icons.balance,
        color: const Color(0xFF38BDF8),
        value: (report) => '${(report.stability * 100).round()}%',
        description: (report) =>
            'محسوب من سجل التفاعلات المحلي، وليس من قيمة تجميلية ثابتة.',
      );

  Widget _buildEngagementChart() => _buildMetricCard(
        title: 'سرعة التفاعل الحالية',
        icon: Icons.speed,
        color: const Color(0xFF818CF8),
        value: (report) => report.engagementVelocity.toStringAsFixed(1),
        description: (report) => 'تفاعل يومياً وفق الفترة المتاحة في السجل.',
      );

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required Color color,
    required String Function(RelationalReport report) value,
    required String Function(RelationalReport report) description,
  }) =>
      FutureBuilder<RelationalReport?>(
        future: _loadReport(),
        builder: (context, snapshot) {
          final hasData = _hasInteractions;
          final report = snapshot.data;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: !hasData
                ? const Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF94A3B8)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'لا توجد تفاعلات كافية لعرض قياس حقيقي بعد.',
                          style: TextStyle(color: Color(0xFFCBD5E1)),
                        ),
                      ),
                    ],
                  )
                : report == null
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                          Icon(icon, color: color, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(value(report),
                                    style: TextStyle(
                                        color: color,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(description(report),
                                    style: const TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
          );
        },
      );

  Widget _buildPrivacyMaintenanceButton() => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton.icon(
          onPressed: () => _handlePrivacyMaintenance(),
          icon: const Icon(Icons.cleaning_services, color: Colors.white),
          label: const Text(
            'صيانة الخصوصية - Privacy Maintenance',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF43F5E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      );

  void _handlePrivacyMaintenance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'تأكيد صيانة البيانات وحماية الخصوصية',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'سيتم تحديث سجلات الخصوصية وتصفير البيانات بشكل آمن '
          'لضمان استقرار النظام. هل تود الاستمرار؟',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await SensoryFeedbackService.errorPulse();
              await PrivacyMaintenanceService.maintenanceReset();
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                      content: Text('تمت عملية صيانة الخصوصية بنجاح 🛡️')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('بدء الصيانة'),
          ),
        ],
      ),
    );
  }

  void _showGovernanceReport() {
    final report =
        InstitutionalGovernanceManager.instance.generateGovernanceReport();
    _showDataDialog('تقرير المعرفية التقنية', report.toString());
  }

  void _showDocsIndex() {
    final index =
        LivingDocumentationSystem.instance.generateDocumentationIndex();
    _showDataDialog('فهرس المعرفة الحية', index);
  }

  void _showDataDialog(String title, String data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Text(data,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
