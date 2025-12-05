import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();

  List<Task> rawTasks = [];   // semua data asli (untuk HomePage)
  List<Task> tasks = [];      // list ter-filter untuk TaskPage

  bool loading = false;
  String statusFilter = ''; // '', 'todo', 'in_progress', 'done'

  // ================================
  // LOAD ALL TASKS (tanpa filter)
  // ================================
  Future<void> loadTasks() async {
    loading = true;
    notifyListeners();

    // ambil semua tasks tanpa filter status
    rawTasks = await _service.fetchTasks();

    // refresh tampilan TaskPage
    _applyFilter();

    loading = false;
    notifyListeners();
  }

  // ================================
  // FILTER TASK PAGE
  // ================================
  void setStatusFilter(String value) {
    statusFilter = value;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (statusFilter.isEmpty) {
      tasks = List.from(rawTasks);
    } else {
      tasks = rawTasks
          .where((t) => t.status == statusFilter)
          .toList();
    }
  }

  // ================================
  // CRUD
  // ================================
  Future<void> addTask(Task task) async {
    await _service.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _service.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _service.deleteTask(id);
    await loadTasks();
  }
}
