import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/infrastructure/institutional_governance_manager.dart';
import '../../../../core/infrastructure/living_documentation_system.dart';
import '../../../../core/infrastructure/wing_logger.dart';
import '../../../../core/security/privacy_maintenance_service.dart';
import '../../../../core/services/sensory_feedback_service.dart';

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

  bool _isGovernanceActive = true;
  bool _isDocsActive = true;
  bool _isResonanceActive = true;

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
            _isGovernanceActive,
            const Color(0xFFF43F5E),
            () {
              SensoryFeedbackService.selectionClick();
              setState(() => _isGovernanceActive = !_isGovernanceActive);
            },
          ),
          _buildEngineCard(
            'التوثيق الحي',
            'Living Docs',
            Icons.auto_stories,
            _isDocsActive,
            const Color(0xFF10B981),
            () {
              SensoryFeedbackService.selectionClick();
              setState(() => _isDocsActive = !_isDocsActive);
            },
          ),
          _buildEngineCard(
            'محرك الرنين',
            'Resonance',
            Icons.graphic_eq,
            _isResonanceActive,
            const Color(0xFF8B5CF6),
            () {
              SensoryFeedbackService.selectionClick();
              setState(() => _isResonanceActive = !_isResonanceActive);
            },
          ),
          _buildEngineCard(
            'الجاذبية العاطفية',
            'Gravity',
            Icons.blur_circular,
            true,
            const Color(0xFFF59E0B),
            () {},
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
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(15),
        ),
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

  Widget _buildStabilityChart() => Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: 7,
            minY: 0,
            maxY: 1,
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 0.5),
                  FlSpot(1, 0.7),
                  FlSpot(2, 0.6),
                  FlSpot(3, 0.8),
                  FlSpot(4, 0.85),
                  FlSpot(5, 0.75),
                  FlSpot(6, 0.9),
                ],
                isCurved: true,
                color: const Color(0xFF38BDF8),
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildEngagementChart() => Container(
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              _makeBarGroup(0, 0.4, const Color(0xFF818CF8)),
              _makeBarGroup(1, 0.6, const Color(0xFF818CF8)),
              _makeBarGroup(2, 0.8, const Color(0xFF818CF8)),
              _makeBarGroup(3, 0.7, const Color(0xFF818CF8)),
              _makeBarGroup(4, 0.9, const Color(0xFFF43F5E)),
            ],
          ),
        ),
      );

  BarChartGroupData _makeBarGroup(int x, double y, Color color) =>
      BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            color: color,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
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
