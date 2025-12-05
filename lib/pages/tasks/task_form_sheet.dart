import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';

class TaskFormSheet extends StatefulWidget {
  final Task? existingTask;

  const TaskFormSheet({super.key, this.existingTask});

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();

  // ERROR VARIABLES
  String? _titleError;
  String? _descError;
  String? _courseError;
  String? _deadlineError;

  String _priority = 'medium';
  String _status = 'todo';
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    final t = widget.existingTask;
    if (t != null) {
      _titleCtrl.text = t.title;
      _descCtrl.text = t.description ?? '';
      _courseCtrl.text = t.course ?? '';
      _priority = t.priority;
      _status = t.status;
      _deadline = t.deadline;
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      initialDate: _deadline ?? now,
    );
    if (result != null) {
      setState(() {
        _deadline = result;
        _deadlineError = null;
      });
    }
  }

  void _validate() {
    setState(() {
      _titleError = _titleCtrl.text.trim().isEmpty ? "Judul wajib diisi" : null;
      _descError = _descCtrl.text.trim().isEmpty ? "Deskripsi wajib diisi" : null;
      _courseError = _courseCtrl.text.trim().isEmpty ? "Mata kuliah wajib diisi" : null;
      _deadlineError = _deadline == null ? "Deadline wajib dipilih" : null;
    });
  }

  Future<void> _save() async {
    _validate();

    // Stop kalau ada error
    if (_titleError != null ||
        _descError != null ||
        _courseError != null ||
        _deadlineError != null) return;

    final provider = context.read<TaskProvider>();

    final task = Task(
      id: widget.existingTask?.id ?? '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      course: _courseCtrl.text.trim(),
      priority: _priority,
      deadline: _deadline,
      status: _status,
    );

    if (widget.existingTask == null) {
      await provider.addTask(task);
    } else {
      await provider.updateTask(task);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingTask != null;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DRAG INDICATOR
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Text(
                  isEdit ? 'Edit Tugas' : 'Tambah Tugas',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 16),

                // Judul
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul Tugas *',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() => _titleError = null),
                ),
                if (_titleError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_titleError!, style: TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 12),

                // Deskripsi
                TextField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi *',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() => _descError = null),
                ),
                if (_descError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_descError!, style: TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 12),

                // Mata Kuliah
                TextField(
                  controller: _courseCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Mata Kuliah *',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() => _courseError = null),
                ),
                if (_courseError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_courseError!, style: TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 12),

                // PRIORITAS
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Prioritas *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Rendah')),
                    DropdownMenuItem(value: 'medium', child: Text('Sedang')),
                    DropdownMenuItem(value: 'high', child: Text('Tinggi')),
                  ],
                  onChanged: (val) => setState(() => _priority = val!),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'todo', child: Text('To Do')),
                    DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                    DropdownMenuItem(value: 'done', child: Text('Done')),
                  ],
                  onChanged: (val) => setState(() => _status = val!),
                ),

                const SizedBox(height: 12),

                // DEADLINE
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _deadline == null
                            ? 'Deadline belum dipilih *'
                            : 'Deadline: ${DateFormat('dd MMM yyyy').format(_deadline!)}',
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Pilih'),
                    ),
                  ],
                ),
                if (_deadlineError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_deadlineError!, style: TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
