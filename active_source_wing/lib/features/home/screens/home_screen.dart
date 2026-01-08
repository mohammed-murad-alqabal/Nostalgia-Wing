import 'package:flutter/material.dart';
import 'dart:math' as math;

// Enhanced screen import
import 'enhanced_home_screen.dart';
import '../../mirror/presentation/screens/intelligence_lab_screen.dart';

/// Main application screen.
class HomeScreen extends StatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State for experimental enhanced UI
  final bool _showEnhancedUI = true;
  String _currentGreeting = 'مرحباً بك في جناح الحنين';

  static final List<String> _greetings = [
    'مرحباً بكِ في جناح الحنين',
    'طاب يومكِ بكل خير وسعادة',
    'أهلاً بكِ في واحة الذكريات',
    'سعيد بلقائكِ مجدداً',
    'لنصنع ذكريات جميلة اليوم',
    'في انتظار همساتكِ الرقيقة',
  ];

  @override
  void initState() {
    super.initState();
    _currentGreeting = _greetings[math.Random().nextInt(_greetings.length)];
  }

  @override
  Widget build(BuildContext context) {
    if (_showEnhancedUI) {
      return const EnhancedHomeScreen();
    }

    // Classic UI (Fallback)
    return Scaffold(
      appBar: AppBar(
        title: const Text('جناح الحنين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.science),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IntelligenceLabScreen(),
                ),
              );
            },
            tooltip: 'مختبر الذكاء',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[50]!,
              Colors.pink[50]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 64,
                color: Colors.pink[300],
              ),
              const SizedBox(height: 16),
              Text(
                _currentGreeting,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'مساحتك الخاصة للذكريات والمشاعر',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'التطبيق يعمل بنجاح',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'تم إنشاؤه بحب ❤️',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
