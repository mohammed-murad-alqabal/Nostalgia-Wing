import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/cognitive/psychological_context_manager.dart';
import '../../../../core/cognitive/relational_analytics_service.dart';
import '../../../../core/psychology/emotional_adaptation_system.dart';
import '../../../../core/psychology/emotional_state.dart';

/// A visual "Mirror" that reflects the user's emotional state.
///
/// Provides dynamic theme adaptation and relational insights.
class EmotionMirrorScreen extends StatelessWidget {
  /// Creates an [EmotionMirrorScreen].
  const EmotionMirrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contextManager = Provider.of<PsychologicalContextManager>(context);
    final analyticsService = Provider.of<RelationalAnalyticsService>(context);
    final adaptationSystem = Provider.of<EmotionalAdaptationSystem>(context);

    return FutureBuilder<RelationalReport>(
      future:
          analyticsService.analyzeRelationalHealth(contextManager.interactions),
      builder: (context, snapshot) {
        final currentEmotion = contextManager.getDominantEmotion();
        final config = adaptationSystem.getEmotionConfiguration(currentEmotion);
        final report = snapshot.data;

        return Scaffold(
          body: adaptationSystem.adaptWidgetToEmotion(
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, currentEmotion, config),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildEmotionalAura(currentEmotion, config),
                          const SizedBox(height: 32),
                          if (report != null) ...[
                            _buildAnalyticsSection(context, report, config),
                            const SizedBox(height: 24),
                            _buildInsightsSection(
                                context, report.insights, config),
                          ] else
                            const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            currentEmotion,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            backgroundColor: config.primaryColor,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, EmotionType emotion,
          ThemeConfiguration config) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرآة الصفاء',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: config.textColor,
                  ),
                ),
                Text(
                  'انعكاس روحك في هذه اللحظة',
                  style: TextStyle(
                    fontSize: 16,
                    color: config.textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: config.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getEmotionIcon(emotion),
                color: config.primaryColor,
                size: 32,
              ),
            ),
          ],
        ),
      );

  Widget _buildEmotionalAura(EmotionType emotion, ThemeConfiguration config) =>
      Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _AnimatedAura(color: config.primaryColor),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: config.primaryColor, width: 2),
              ),
              child: Text(
                _getEmotionArabicName(emotion),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: config.textColor,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildAnalyticsSection(BuildContext context, RelationalReport report,
          ThemeConfiguration config) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التحليل العاطفي',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: config.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'الاستقرار',
                  value: '${(report.stability * 100).toInt()}%',
                  icon: Icons.account_balance_wallet,
                  config: config,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  label: 'التفاعل',
                  value: report.engagementVelocity.toStringAsFixed(1),
                  icon: Icons.speed,
                  config: config,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildInsightsSection(BuildContext context, List<String> insights,
          ThemeConfiguration config) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(config.borderRadius),
          border: Border.all(color: config.primaryColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: config.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'رؤى الرفيق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: config.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...insights.map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ',
                          style: TextStyle(
                              color: config.primaryColor,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          insight,
                          style:
                              TextStyle(color: config.textColor, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );

  IconData _getEmotionIcon(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return Icons.sentiment_very_satisfied;
      case EmotionType.sad:
        return Icons.sentiment_very_dissatisfied;
      case EmotionType.joy:
        return Icons.celebration;
      case EmotionType.calm:
        return Icons.self_improvement;
      case EmotionType.love:
        return Icons.favorite;
      case EmotionType.nostalgic:
        return Icons.history_edu;
      default:
        return Icons.sentiment_neutral;
    }
  }

  String _getEmotionArabicName(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 'سعيد';
      case EmotionType.sad:
        return 'حزين';
      case EmotionType.joy:
        return 'مبتهج';
      case EmotionType.calm:
        return 'هادئ';
      case EmotionType.love:
        return 'محب';
      case EmotionType.nostalgic:
        return 'حنون';
      case EmotionType.neutral:
        return 'متزن';
      default:
        return 'مستقر';
    }
  }
}

class _AnimatedAura extends StatefulWidget {
  const _AnimatedAura({required this.color});
  final Color color;

  @override
  State<_AnimatedAura> createState() => _AnimatedAuraState();
}

class _AnimatedAuraState extends State<_AnimatedAura>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          width: 200 + (50 * _controller.value),
          height: 200 + (50 * _controller.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color
                    .withValues(alpha: 0.2 * (1 - _controller.value)),
                blurRadius: 40,
                spreadRadius: 20 * _controller.value,
              ),
            ],
          ),
        ),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.config,
  });

  final String label;
  final String value;
  final IconData icon;
  final ThemeConfiguration config;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(config.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: config.primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: config.textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: config.textColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
}
