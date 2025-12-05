// lib/services/task_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Task>> fetchTasks({String? status}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final List data;

    if (status != null && status.isNotEmpty) {
      // ✅ DENGAN FILTER STATUS
      data = await _client
          .from('tasks')
          .select()
          .eq('user_id', userId)
          .eq('status', status)
          .order('created_at', ascending: false);
    } else {
      // ✅ TANPA FILTER STATUS
      data = await _client
          .from('tasks')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
    }

    return data
        .map((e) => Task.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addTask(Task task) async {
    final userId = _client.auth.currentUser!.id;

    await _client.from('tasks').insert(
      task.toInsertMap(userId),
    );
  }

  Future<void> updateTask(Task task) async {
    await _client
        .from('tasks')
        .update(task.toUpdateMap())
        .eq('id', task.id);
  }

  Future<void> deleteTask(String id) async {
    await _client
        .from('tasks')
        .delete()
        .eq('id', id);
  }
}
