import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    // ambil semua tasks tanpa filter status
    final now = DateTime.now();

    final upcoming = provider.rawTasks.where((task) {
      // hanya tampilkan todo & in_progress
      final statusOk =
          task.status == 'todo' || task.status == 'in_progress';

      // hanya yang punya deadline
      if (task.deadline == null) return false;

      final diff = task.deadline!.difference(now).inDays;

      // deadline ≤ H-2
      final isNear =
          diff >= 0 && diff <= 2; // tidak lewat tenggat + max 2 hari

      return statusOk && isNear;
    }).toList()
      ..sort((a, b) =>
          (a.deadline ?? now).compareTo(b.deadline ?? now));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Mendekati Tenggat'),
        backgroundColor: const Color(0xFF0E5C56),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: upcoming.isEmpty
          ? const Center(child: Text('Tidak ada tugas dalam 2 hari'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: upcoming.length,
        itemBuilder: (_, i) => _TaskDeadlineCard(task: upcoming[i]),
      ),
    );
  }
}

class _TaskDeadlineCard extends StatelessWidget {
  final Task task;
  const _TaskDeadlineCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(
          'Deadline: ${DateFormat('dd MMM yyyy').format(task.deadline!)}',
        ),
        trailing: const Icon(Icons.alarm, color: Colors.orange),
      ),
    );
  }
}
