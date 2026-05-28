import 'package:flutter/material.dart';
import '../utils/storage_service.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  int _glasses = 0;
  final int _goal = 8;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final water = await StorageService.getWater();
    setState(() => _glasses = water);
  }

  Future<void> _update(int value) async {
    final newVal = (_glasses + value).clamp(0, 12);
    await StorageService.setWater(newVal);
    setState(() => _glasses = newVal);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_glasses / _goal).clamp(0.0, 1.0);
    final done = _glasses >= _goal;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Water Intake'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // big glass count
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue, width: 3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💧', style: TextStyle(fontSize: 36)),
                  Text('$_glasses',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
                  Text('of $_goal glasses', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 14,
                backgroundColor: Colors.blue.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              done ? 'Goal reached! Great job!' : '${_goal - _glasses} more to reach your goal',
              style: TextStyle(
                color: done ? Colors.green : Colors.grey,
                fontWeight: done ? FontWeight.bold : FontWeight.normal,
              ),
            ),

            const SizedBox(height: 40),

            // controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circleButton(Icons.remove, Colors.red.shade100, Colors.red, () => _update(-1)),
                const SizedBox(width: 24),
                _circleButton(Icons.add, Colors.blue.shade100, Colors.blue, () => _update(1)),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Tap + to add a glass, - to remove one',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(
      IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 30),
      ),
    );
  }
}
