import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/storage_service.dart';
import 'workout_screen.dart';
import 'water_screen.dart';
import 'mood_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _waterGlasses = 0;
  List<String> _workouts = [];
  String _mood = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await StorageService.checkAndResetDaily();
    final water = await StorageService.getWater();
    final workouts = await StorageService.getWorkouts();
    final mood = await StorageService.getMood();
    setState(() {
      _waterGlasses = water;
      _workouts = workouts;
      _mood = mood;
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              Text(
                '$_greeting 💪',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE91E8C),
                ),
              ),
              Text(today, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 24),

              // daily summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.pink.shade50, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's summary",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _summaryRow('💧', 'Water', '$_waterGlasses / 8 glasses'),
                    _summaryRow('🏋️', 'Workouts', '${_workouts.length} logged'),
                    _summaryRow('😊', 'Mood', _mood.isEmpty ? 'Not set yet' : _mood),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              Text('Track your day',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // action cards
              _actionCard(
                context,
                icon: Icons.fitness_center,
                color: const Color(0xFFE91E8C),
                title: 'Log a workout',
                subtitle: '${_workouts.length} logged today',
                onTap: () async {
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const WorkoutScreen()));
                  _loadData();
                },
              ),
              const SizedBox(height: 12),
              _actionCard(
                context,
                icon: Icons.water_drop,
                color: Colors.blue,
                title: 'Water intake',
                subtitle: '$_waterGlasses of 8 glasses',
                onTap: () async {
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const WaterScreen()));
                  _loadData();
                },
              ),
              const SizedBox(height: 12),
              _actionCard(
                context,
                icon: Icons.mood,
                color: Colors.orange,
                title: 'Mood check-in',
                subtitle: _mood.isEmpty ? 'How are you feeling?' : _mood,
                onTap: () async {
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const MoodScreen()));
                  _loadData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.pink.shade50, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
