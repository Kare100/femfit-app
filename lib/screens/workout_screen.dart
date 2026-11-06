import 'package:flutter/material.dart';
import '../utils/storage_service.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<String> _workouts = [];
  final _controller = TextEditingController();

  final List<String> _suggestions = [
    '30 min run',
    '20 min yoga',
    '45 min gym',
    '15 min stretching',
    '30 min cycling',
    '20 min HIIT',
    '1 hour walk',
    '30 min swimming',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final workouts = await StorageService.getWorkouts();
    setState(() => _workouts = workouts);
  }

  Future<void> _add(String workout) async {
    if (workout.trim().isEmpty) return;
    await StorageService.addWorkout(workout.trim());
    _controller.clear();
    _load();
  }

  Future<void> _remove(int index) async {
    await StorageService.removeWorkout(index);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E8C),
        foregroundColor: Colors.white,
        title: const Text('Workout Logger'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'e.g. 30 min run',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _add,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _add(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E8C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // quick suggestions
            const Text('Quick add:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestions
                  .map((s) => GestureDetector(
                        onTap: () => _add(s),
                        child: Chip(
                          label: Text(s, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.pink.shade50,
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 20),
            Text("Today's workouts (${_workouts.length})",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: _workouts.isEmpty
                  ? const Center(
                      child: Text('No workouts logged yet', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _workouts.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFFE91E8C), size: 20),
                            const SizedBox(width: 10),
                            Expanded(child: Text(_workouts[index])),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                              onPressed: () => _remove(index),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
