// lib/pages/tasks/task_list_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../../providers/auth_provider.dart';
import 'task_form_sheet.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<TaskProvider>().loadTasks(),
    );
  }

  void _openTaskForm({Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskFormSheet(existingTask: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFA),

      appBar: AppBar(
        title: Text(
          auth.currentUser != null
              ? 'DoItNow - ${auth.currentUser!.name}'
              : 'DoItNow',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E5C56),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          // ======================
          // FILTER STATUS
          // ======================
          Container(
            margin: const EdgeInsets.fromLTRB(12, 14, 12, 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _StatusChip(label: 'Semua', value: ''),
                _StatusChip(label: 'To Do', value: 'todo'),
                _StatusChip(label: 'Progress', value: 'in_progress'),
                _StatusChip(label: 'Done', value: 'done'),
              ],
            ),
          ),

          // ======================
          // LIST TASK
          // ======================
          Expanded(
            child: taskProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : taskProvider.tasks.isEmpty
                ? const _EmptyState()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return _TaskCard(
                  task: task,
                  onTap: () => _openTaskForm(task: task),
                  onDelete: () =>
                      taskProvider.deleteTask(task.id),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0E5C56),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _openTaskForm(),
      ),
    );
  }
}

//
// ======================
// TASK CARD
// ======================
//
class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        dense: true,
        onTap: onTap,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(_buildSubtitle(task)),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusIcon(status: task.status),
            const SizedBox(width: 8),

            // ======================
            // KONFIRMASI HAPUS
            // ======================
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Hapus Tugas?"),
                      content: const Text(
                        "Apakah kamu yakin ingin menghapus tugas ini?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  onDelete();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(Task task) {
    final parts = <String>[];

    if (task.course != null && task.course!.isNotEmpty) {
      parts.add(task.course!);
    }

    if (task.deadline != null) {
      parts.add(
        'Tenggat: ${DateFormat('dd MMM yyyy').format(task.deadline!)}',
      );
    }

    parts.add('Status: ${_statusLabel(task.status)}');

    return parts.join(' • ');
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'todo':
        return 'To Do';
      case 'in_progress':
        return 'Progress';
      case 'done':
        return 'Done';
      default:
        return status;
    }
  }
}

//
// ======================
// STATUS CHIP
// ======================
//
class _StatusChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatusChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final selected = provider.statusFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: const Color(0xFF0E5C56),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        onSelected: (_) => provider.setStatusFilter(value),
      ),
    );
  }
}

//
// ======================
// STATUS ICON
// ======================
//
class _StatusIcon extends StatelessWidget {
  final String status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status) {
      case 'todo':
        color = Colors.grey;
        icon = Icons.radio_button_unchecked;
        break;
      case 'in_progress':
        color = Colors.orange;
        icon = Icons.timelapse;
        break;
      case 'done':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.blue;
        icon = Icons.help;
    }

    return Icon(icon, color: color, size: 22);
  }
}

//
// ======================
// EMPTY STATE
// ======================
//
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Belum ada tugas',
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }
}
